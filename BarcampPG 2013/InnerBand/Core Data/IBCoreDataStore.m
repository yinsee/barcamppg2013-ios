//
//  IBCoreDataCoreDataStore.m
//  InnerBand
//
//  InnerBand - The iOS Booster!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IBCoreDataStore.h"
#import "IBFunctions.h"

// global Core Data objects
__strong static NSManagedObjectModel *gManagedObjectModel = nil;
__strong static NSPersistentStoreCoordinator *gPersistentStoreCoordinator = nil;
__strong static NSString *gStorePathname = nil;
__strong static NSString *gModelPathname = nil;

// main thread singleton
static IBCoreDataStore *gMainStoreInstance;

@interface IBCoreDataStore ()

- (void)createManagedObjectContext;

@end

@implementation IBCoreDataStore

+ (IBCoreDataStore *)mainStore {
	@synchronized (self) {
        [self configureCoreData];

		if (!gMainStoreInstance) {
			gMainStoreInstance = [[IBCoreDataStore alloc] init];
		}
	}

	return gMainStoreInstance;
}

+ (IBCoreDataStore *)createStore {
	@synchronized (self) {
        [self configureCoreData];
    }

    return [[IBCoreDataStore alloc] init];
}

+ (void)setStorePathname:(NSString *)path {
    gStorePathname = [path copy];
}

+ (void)setModelPathname:(NSString *)path {
    gModelPathname = [path copy];
}

+ (void)configureCoreData {
    // just once
    if (gManagedObjectModel) {
        return;
    }

	NSError *error = nil;

	// create the global managed object model
    if (gModelPathname) {
        // specific
        NSURL *modelURL = [NSURL fileURLWithPath:gModelPathname];
        gManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    } else {
        // automatic
        gManagedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }

	// create the global persistent store
    gPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:gManagedObjectModel];

    if (!gStorePathname) {
        // default name
        gStorePathname = [[IB_DOCUMENTS_DIR() stringByAppendingPathComponent:@"CoreDataStore.sqlite"] copy];
    }

	NSURL *storeURL = [NSURL fileURLWithPath:gStorePathname];

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             IB_BOX_BOOL(YES), NSMigratePersistentStoresAutomaticallyOption,
                             IB_BOX_BOOL(YES), NSInferMappingModelAutomaticallyOption, nil];

	if (![gPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
		NSLog(@"Error creating persistantStoreCoordinator: %@, %@", error, [error userInfo]);
		abort();
    }
}

+ (IBCoreDataStore *)createStoreWithContext:(NSManagedObjectContext *)context {
    return [[IBCoreDataStore alloc] initWithContext:context];
}

- (id)init {
	if ((self = [super init])) {
		[self createManagedObjectContext];
	}

	return self;
}

- (id)initWithContext:(NSManagedObjectContext *)context {
	if ((self = [super init])) {
        _managedObjectContext = context;
	}

	return self;
}

#pragma mark -

- (NSManagedObjectContext *)context {
	return _managedObjectContext;
}

+ (void)clearAllData {
	NSError *error = nil;

	// clear existing stack
    gManagedObjectModel = nil;
    gPersistentStoreCoordinator = nil;

    @synchronized (self) {
        gMainStoreInstance = nil;
    }

	// remove persistence file
    if (gStorePathname) {
        NSURL *storeURL = [NSURL fileURLWithPath:gStorePathname];

        // remove
        @try {
            [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
        } @catch (NSException *exception) {
            // ignore, totally normal
        }
    }
}

/**
 Save the context.
 */
- (void)save {
	NSError *error = nil;

	if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];

		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
	}
}

#pragma mark - Deprecated Accessors (Use NSManagedObject+InnerBand)

- (NSArray *)allForEntity:(NSString *)entityName error:(NSError **)error {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];

	// execute
	NSArray *ret = [_managedObjectContext executeFetchRequest:request error:error];

	return ret;
}

- (NSArray *)allForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];

	// predicate
	[request setPredicate:predicate];

	// execute
	return [_managedObjectContext executeFetchRequest:request error:error];
}

- (NSArray *)allForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending error:(NSError **)error {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];

	// predicate
	[request setPredicate:predicate];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

	// execute
	return [_managedObjectContext executeFetchRequest:request error:error];
}

- (NSArray *)allForEntity:(NSString *)entityName orderBy:(NSString *)key ascending:(BOOL)ascending error:(NSError **)error {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];

	// predicate
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

	// execute
	return [_managedObjectContext executeFetchRequest:request error:error];
}

- (NSManagedObject *)entityByName:(NSString *)entityName error:(NSError **)error {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];

	// execute
	NSArray *values = [_managedObjectContext executeFetchRequest:request error:error];

	if (values.count > 0) {
		// this method is designed for accessing a single object, but if there's more just give the first
		return (NSManagedObject *)[values objectAtIndex:0];
	}

	return nil;
}

- (NSManagedObject *)entityByName:(NSString *)entityName key:(NSString *)key value:(id)value error:(NSError **)error {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];

	// predicate
	[request setPredicate:predicate];

	// execute
	NSArray *values = [_managedObjectContext executeFetchRequest:request error:error];

	if (values.count > 0) {
		// this method is designed for accessing a single object, but if there's more just give the first
		return (NSManagedObject *)[values objectAtIndex:0];
	}

	return nil;
}

- (NSManagedObject *)entityByURI:(NSURL *)uri {
	NSManagedObjectID *oid = [gPersistentStoreCoordinator managedObjectIDForURIRepresentation:uri];

    return [self entityByObjectID:oid];
}

- (NSManagedObject *)entityByObjectID:(NSManagedObjectID *)oid {
	if (oid) {
		return [_managedObjectContext objectWithID:oid];
	}

	return nil;
}

- (NSManagedObject *)createNewEntityByName:(NSString *)entityName {
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_managedObjectContext];
}

- (void)removeEntity:(NSManagedObject *)entity {
	@try {
		[_managedObjectContext deleteObject:entity];
	} @catch(id exception) {}
}

/* Remove all objects of an entity. */
- (void)removeAllEntitiesByName:(NSString *)entityName {
	NSError *error = nil;

	// get all objects for entity
	// TODO: we can fetch these in a more minimalistic way, would be faster, so do it if we have time
	NSArray *objects = [self allForEntity:entityName error:&error];

	for (NSManagedObject *iObject in objects) {
		[_managedObjectContext deleteObject:iObject];
	}
}

- (NSEntityDescription *)entityDescriptionForEntity:(NSString *)entityName {
	return [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
}

#pragma mark -

- (void)createManagedObjectContext {
	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	[_managedObjectContext setPersistentStoreCoordinator:gPersistentStoreCoordinator];
}

@end
