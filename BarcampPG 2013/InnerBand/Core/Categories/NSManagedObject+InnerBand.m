//
//  NSManagedObject+InnerBand.m
//  InnerBand
//
//  Created by John Blanco on 8/13/11.
//  Copyright 2011 Double Encore. All rights reserved.
//

#import "NSManagedObject+InnerBand.h"
#import <objc/runtime.h>
#import "IBCoreDataStore.h"

@class CoreDataStore;

@implementation NSManagedObject (InnerBand)

+ (id)create {
    return [self createInStore:[IBCoreDataStore mainStore]];
}

+ (id)createInStore:(IBCoreDataStore *)store {
    return [store createNewEntityByName:NSStringFromClass(self.class)];
}

+ (NSArray *)all {
    return [self allInStore:[IBCoreDataStore mainStore]];
}

+ (NSArray *)allForPredicate:(NSPredicate *)predicate {
    return [self allForPredicate:predicate inStore:[IBCoreDataStore mainStore]];
}

+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending {
    return [self allForPredicate:predicate orderBy:key ascending:ascending inStore:[IBCoreDataStore mainStore]];
}

+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending {
    return [self allOrderedBy:key ascending:ascending inStore:[IBCoreDataStore mainStore]];
}

+ (NSArray *)allInStore:(IBCoreDataStore *)store {
    NSError *error = nil;
    return [store allForEntity:NSStringFromClass(self.class) error:&error];    
}

+ (NSArray *)allForPredicate:(NSPredicate *)predicate inStore:(IBCoreDataStore *)store {
    NSError *error = nil;
    return [store allForEntity:NSStringFromClass(self.class) predicate:predicate error:&error];
}

+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inStore:(IBCoreDataStore *)store {
    NSError *error = nil;
    return [store allForEntity:NSStringFromClass(self.class) predicate:predicate orderBy:key ascending:ascending error:&error];    
}

+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending inStore:(IBCoreDataStore *)store {
    NSError *error = nil;
    return [store allForEntity:NSStringFromClass(self.class) orderBy:key ascending:ascending error:&error];
}

+ (id)first {
    return [self firstInStore:[IBCoreDataStore mainStore]];
}

+ (id)firstWithKey:(NSString *)key value:(id)value {
    return [self firstWithKey:key value:value inStore:[IBCoreDataStore mainStore]];
}

+ (id)firstInStore:(IBCoreDataStore *)store {
    NSError *error = nil;
    return [store entityByName:NSStringFromClass(self.class) error:&error];    
}

+ (id)firstWithKey:(NSString *)key value:(id)value inStore:(IBCoreDataStore *)store {
    NSError *error = nil;
    return [store entityByName:NSStringFromClass(self.class) key:key value:value error:&error];    
}

- (void)destroy {
    [self.managedObjectContext deleteObject:self];
}

+ (void)destroyAll {
    return [self destroyAllInStore:[IBCoreDataStore mainStore]];
}

+ (void)destroyAllInStore:(IBCoreDataStore *)store {
    return [store removeAllEntitiesByName:NSStringFromClass(self.class)];
}

@end
