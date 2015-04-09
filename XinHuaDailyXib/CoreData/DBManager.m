//
//  DBManager.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/9.
//
//

#import "DBManager.h"
#define KSQLFile @"DB.sqlite"
@implementation DBManager{
    NSString*   _databasepath;
    NSManagedObjectModel * _managedObjectModel;
    NSPersistentStoreCoordinator * _persistentStoreCoordinator;
    DBOperator *_foreground_operator;
    NSManagedObjectContext *_foreground_context;
}
-(id)init{
    @synchronized(self){
        if(self=[super init]){
            [self persistentStoreCoordinator];
            _foreground_context=[[NSManagedObjectContext alloc] init];
            [_foreground_context setUndoManager:nil];// We're not using undo. By setting it to nil we reduce the memory footprint of the app
            _foreground_context.persistentStoreCoordinator=_persistentStoreCoordinator;
            _foreground_operator=[[DBOperator alloc] initWithContext:_foreground_context];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(mergeChanges:)
                                                         name:NSManagedObjectContextDidSaveNotification
                                                       object:nil];
        }
    }
    return self;
}
-(DBOperator *)theForegroundOperator{
    return _foreground_operator;
}

-(DBOperator *)aBackgroundOperator{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc] init];
    [context setUndoManager:nil];// We're not using undo. By setting it to nil we reduce the memory footprint of the app
    context.persistentStoreCoordinator=_persistentStoreCoordinator;
    DBOperator *operator=[[DBOperator alloc] initWithContext:context];
    return operator;
}
- (NSManagedObjectModel *)managedObjectModel
{
    //设置数据库文件存储位置
    NSString *dcoumentpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _databasepath = [NSString stringWithFormat:@"%@/%@",dcoumentpath,KSQLFile];
    
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"momd"];
    NSLog(@"%@",_databasepath);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath: _databasepath] options:options error:&error])
    {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:_databasepath error:nil];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath: _databasepath] options:options error:nil];
    }
    
    return _persistentStoreCoordinator;
}
// merge changes to main context,fetchedRequestController will automatically monitor the changes and update tableview.
- (void)updateMainContext:(NSNotification *)notification {
    
    assert([NSThread isMainThread]);
    [_foreground_context mergeChangesFromContextDidSaveNotification:notification];
}

// this is called via observing "NSManagedObjectContextDidSaveNotification" from our APLParseOperation
- (void)mergeChanges:(NSNotification *)notification {
    
    if (notification.object != _foreground_context) {
        [self performSelectorOnMainThread:@selector(updateMainContext:) withObject:notification waitUntilDone:NO];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:nil];
}
@end
