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
}
-(id)init{
    @synchronized(self){
        if(self=[super init]){
            [self persistentStoreCoordinator];
        }
    }
    return self;
}
-(DBOperator *)aOperator{
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

@end
