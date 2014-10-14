//
//  UserActions.h
//  XinHuaDailyXib
//
//  Created by apple on 13-9-4.
//
//

#import <Foundation/Foundation.h>
#import "Communicator.h"
#import "UserAction.h"
@interface UserActions : NSObject<NSURLConnectionDelegate>{
   NSMutableArray* m_array;
}
- (id)initWithCommunicator:(Communicator *)communicator;
-(void)enqueueAReadAction:(NSString *)article_id;
-(void)reportActionsToServer:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
@property (nonatomic, readonly) int count;
@end
