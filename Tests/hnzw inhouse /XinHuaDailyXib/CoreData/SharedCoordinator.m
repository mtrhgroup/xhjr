//
//  SharedCoordinator.m
//  CampusNewsLetter
//
//  Created by apple on 13-1-9.
//
//

#import "SharedCoordinator.h"
#define KSQLFile @"news.sqlite"
static SharedCoordinator *instance=nil;
@implementation SharedCoordinator
@synthesize databasepath;
- (id)initWithFile:(NSString*)dbPath
{
    if ((self = [super init]))
	{
		self.databasepath = dbPath;		
	}
	return self;
}
+(SharedCoordinator *)sharedInstance{
    if(instance==nil){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dcoumentpath = ([paths count] > 0)? [paths objectAtIndex:0] : nil;
        NSString*  dbpath = [NSString stringWithFormat:@"%@/%@",dcoumentpath,KSQLFile];
        instance=[[SharedCoordinator alloc]initWithFile:dbpath];
    }
    return instance;
}
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
- (void)dealloc {
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[databasepath release];
	[super dealloc];
}
@end
