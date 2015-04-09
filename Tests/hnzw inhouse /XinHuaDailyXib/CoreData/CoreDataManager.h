//
//  HaloCoreDataManager.h
//  Youlu
//
//  Created by William on 11-9-14.
//  Copyright 2010 Youlu . All rights reserved.
//

#import <CoreData/CoreData.h>
@interface CoreDataManager : NSObject
{
    NSString*   databasepath;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSLock          *lock;
}
@property (nonatomic, readonly)NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain)NSString*  databasepath;

- (id)initWithFile:(NSString*)dbPath;
- (BOOL)SaveDb;
    //- (void)CloseDatabase;
- (NSArray*)searchObjectsByName: (NSString*)entityName  predicate:(NSPredicate *)predicate sortKey:(NSString*)sortKey sortAscending:(BOOL)sortAscending limited:(NSUInteger)limit;
- (NSArray*)getObjectsByName: (NSString*)entityName sortKey:(NSString*)sortKey sortAscending: (BOOL)sortAscending limited:(NSUInteger)limit;
- (NSArray*)getObjectsByName: (NSString*)entityName predicate:(NSPredicate*)predict limited:(NSUInteger)limit;
- (NSFetchedResultsController*)copyFetchedResultControllerByEntityName:(NSString*)name sort:(NSArray*)sort sectionName:(NSString*)sectionName predicate:(NSPredicate*)predicate limited:(NSUInteger)limit;



@end

