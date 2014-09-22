//
//  SharedCoordinator.h
//  CampusNewsLetter
//
//  Created by apple on 13-1-9.
//
//

#import <Foundation/Foundation.h>

@interface SharedCoordinator : NSObject{
    NSString*   databasepath;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (nonatomic, strong)NSString*  databasepath;
@property (nonatomic, readonly)NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly)NSPersistentStoreCoordinator *persistentStoreCoordinator;
+(SharedCoordinator *)sharedInstance;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
@end