//
//  UserAction.m
//  XinHuaDailyXib
//
//  Created by apple on 13-9-4.
//
//

#import "UserAction.h"

@implementation UserAction
@synthesize action_type;
@synthesize action_time;
@synthesize action_target;
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:action_type forKey:@"TYPE"];
    [aCoder encodeObject:action_time forKey:@"TIME"];
    [aCoder encodeObject:action_target forKey:@"TARGET"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if(self){
        self.action_type=[aDecoder decodeObjectForKey:@"TYPE"];
        self.action_time=[aDecoder decodeObjectForKey:@"TIME"];
        self.action_target=[aDecoder decodeObjectForKey:@"TARGET"];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    UserAction *actions=[[[self class] allocWithZone:zone]init];
    actions.action_type=self.action_type;
    actions.action_time=self.action_time;
    actions.action_target=self.action_target;
    return actions;
}
@end
