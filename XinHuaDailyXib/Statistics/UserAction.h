//
//  UserAction.h
//  XinHuaDailyXib
//
//  Created by apple on 13-9-4.
//
//

#import <Foundation/Foundation.h>

@interface UserAction : NSObject<NSCoding,NSCopying>
@property(strong,nonatomic)NSString *action_type;
@property(strong,nonatomic)NSDate *action_time;
@property(strong,nonatomic)NSString *action_target;
@end
