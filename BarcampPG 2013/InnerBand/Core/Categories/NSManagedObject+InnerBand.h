//
//  NSManagedObject+InnerBand.h
//  InnerBand
//
//  Created by John Blanco on 8/13/11.
//  Copyright 2011 Double Encore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IBCoreDataStore.h"

@interface NSManagedObject (InnerBand)

// CREATION

+ (id)create;
+ (id)createInStore:(IBCoreDataStore *)store;

// QUERY

+ (NSArray *)all;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allInStore:(IBCoreDataStore *)store;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate inStore:(IBCoreDataStore *)store;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inStore:(IBCoreDataStore *)store;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending inStore:(IBCoreDataStore *)store;

+ (id)first;
+ (id)firstWithKey:(NSString *)key value:(id)value;

+ (id)firstInStore:(IBCoreDataStore *)store;
+ (id)firstWithKey:(NSString *)key value:(id)value inStore:(IBCoreDataStore *)store;

// DELETE/DESTROY

+ (void)destroyAll;
+ (void)destroyAllInStore:(IBCoreDataStore *)store;

- (void)destroy;

@end
