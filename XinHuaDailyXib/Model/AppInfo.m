//
//  VersionInfo.m
//  XinHuaDailyXib
//
//  Created by apple on 13-8-9.
//
//

#import "AppInfo.h"

@implementation AppInfo
@synthesize snState;
@synthesize snMsg;
@synthesize groupTitle;
@synthesize groupSubTitle;
@synthesize startImgUrl;
@synthesize gid;
@synthesize advPath;
@synthesize advPagePath;
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.snState forKey:@"sn_state"];
    [aCoder encodeObject:self.snMsg forKey:@"sn_msg"];
    [aCoder encodeObject:self.groupTitle forKey:@"group_title"];
    [aCoder encodeObject:self.groupSubTitle forKey:@"group_subTitle"];
    [aCoder encodeObject:self.startImgUrl forKey:@"start_image"];
    [aCoder encodeObject:self.gid forKey:@"gid"];
    [aCoder encodeObject:self.advPath forKey:@"advPath"];
    [aCoder encodeObject:self.advPagePath forKey:@"advPagePath"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.snState = [aDecoder decodeObjectForKey:@"sn_state"];
        self.snMsg = [aDecoder decodeObjectForKey:@"sn_msg"];
        self.groupTitle = [aDecoder decodeObjectForKey:@"group_title"];
        self.groupSubTitle = [aDecoder decodeObjectForKey:@"group_subTitle"];
        self.startImgUrl = [aDecoder decodeObjectForKey:@"start_image"];
        self.gid=[aDecoder decodeObjectForKey:@"gid"];
        self.advPath=[aDecoder decodeObjectForKey:@"advPath"];
        self.advPagePath=[aDecoder decodeObjectForKey:@"advPagePath"];
     }
    return self;
}
@end
