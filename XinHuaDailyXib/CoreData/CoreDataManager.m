//
//  HaloCoreDataManager.m
//  Youlu
//
//  Created by William on 11-9-14.
//  Copyright 2010 Youlu . All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager
@synthesize databasepath;
#pragma mark -

- (id)initWithFile:(NSString*)dbPath
{
	if ((self = [super init]))
	{
        lock  =[[NSLock alloc] init];
		self.databasepath = dbPath;
		// Override point for customization after app launch    
		NSManagedObjectContext *context = [self managedObjectContext];
		
		// We're not using undo. By setting it to nil we reduce the memory footprint of the app
		[context setUndoManager:nil];
		
		if (!context){
			Logger(@"Error initializing object model context");
			exit(-1);
		}
		
	}
	return self;
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil)
    {
		return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel 
{

	if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
//#if (!TARGET_IPHONE_SIMULATOR)
//    managedObjectModel =  [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
//#else
	NSString* name = [[self.databasepath lastPathComponent] stringByDeletingPathExtension];
	Logger(@"DB name:%@",name);
	NSString *modelPath = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//#endif
	return managedObjectModel;	
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
	NSURL *storeUrl = [NSURL fileURLWithPath: self.databasepath];	
    NSError *error = nil;
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error])
    {
        Logger(@"Error: %@",error);
        Logger(@"Unresolved error %@, %@", error, [error userInfo]);
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:self.databasepath error:nil];
		[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:nil];
    }    

    return persistentStoreCoordinator;
}

- (BOOL)SaveDb
{
    if (![NSThread isMainThread]) 
    {
        while (YES)
        {
            if ([lock tryLock])
            {
                break;
            }
            else
            {
                LoggerS(@"wait save");
                [NSThread sleepForTimeInterval:0.1f];
            }
        }
    }
    
    BOOL result = NO;
    NSError *error;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges])
        {
            result = [managedObjectContext save:&error];
            if(!result)
            {
                    // Handle error
                Logger(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(-1);  // Fail
            }
            Logger(@"Youlu SQLLite Saved");
        } 
    }    
    if (![NSThread isMainThread])
    {
        [lock unlock];   
    }
    return YES;
   // return result;
}

//- (void)CloseDatabase
//{
//	[self save];
//	[managedObjectContext release];
//    [managedObjectModel release];
//    [persistentStoreCoordinator release];
//	
//	managedObjectContext = nil;
//	managedObjectModel = nil;
//	persistentStoreCoordinator = nil;
//}

- (NSArray*)searchObjectsByName: (NSString*)entityName  predicate:(NSPredicate *)predicate sortKey:(NSString*)sortKey sortAscending:(BOOL)sortAscending  limited:(NSUInteger)limit
{
	if (![NSThread isMainThread]) 
    {
        while (YES)
        {
            if ([lock tryLock])
            {
                break;
            }
            else
            {
                LoggerS(@"wait searchObjectsByName");
                [NSThread sleepForTimeInterval:0.1f];
            }
        }
    }
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];	
	if (limit > 0)
	{
		[request setFetchLimit:limit];
	}
	
	// If a predicate was passed, pass it to the query
	if(predicate != nil)
	{
		[request setPredicate:predicate];
	}
	
	// If a sort key was passed, use it for sorting.
	if(sortKey != nil)
	{
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
	}
	
	NSError *error;
    NSArray* result = [managedObjectContext executeFetchRequest:request error:&error];
	if (![NSThread isMainThread])
    {
        [lock unlock];   
    }
	return result;
}

- (NSArray *)getObjectsByName: (NSString*)entityName sortKey:(NSString*)sortKey sortAscending:(BOOL)sortAscending limited:(NSUInteger)limit
{	
	return [self searchObjectsByName:entityName  predicate:nil sortKey:sortKey sortAscending:sortAscending limited:limit];
}

- (NSArray *)getObjectsByName: (NSString*)entityName predicate:(NSPredicate*)predict limited:(NSUInteger)limit
{
	return [self searchObjectsByName:entityName  predicate:predict sortKey:nil sortAscending:NO limited:limit];	
}

- (NSFetchedResultsController*)copyFetchedResultControllerByEntityName:(NSString*)name 
																   sort:(NSArray*)sort 
															sectionName:(NSString*)sectionName 
															  predicate:(NSPredicate*)predicate 
																limited:(NSUInteger)limited
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:[self managedObjectContext]]];
    [fetchRequest setIncludesSubentities:NO];
	if(sort)
	{
		[fetchRequest setSortDescriptors:sort];
	}
    else
    {
        [fetchRequest setSortDescriptors:[NSArray array]];
    }
	if(predicate)
	{
		[fetchRequest setPredicate:predicate];
	}

	if(limited>0)
	{
		[fetchRequest setFetchLimit:limited];
	}
	NSFetchedResultsController* fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																							  managedObjectContext:[self managedObjectContext] 
																								sectionNameKeyPath:sectionName cacheName:nil];
	[fetchedResultController performFetch:nil];
    
    return fetchedResultController;
}



@end

