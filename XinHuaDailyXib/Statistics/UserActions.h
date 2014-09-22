//
//  UserActions.h
//  XinHuaDailyXib
//
//  Created by apple on 13-9-4.
//
//

#import <Foundation/Foundation.h>
@class UserAction;
@interface UserActions : NSObject<NSURLConnectionDelegate>{
   NSMutableArray* m_array;
}
+(UserActions *)sharedInstance;
-(void)enqueueAReadAction:(NSString *)article_id;
-(void)reportActionsToServer;
@property (nonatomic, readonly) int count;
@end
