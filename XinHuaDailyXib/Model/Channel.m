//
//  Channel.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import "Channel.h"
#import "ChannelMO.h"
@implementation Channel
@synthesize channel_id=_channel_id;
@synthesize channel_name=_channel_name;
@synthesize description=_description;
@synthesize sort_number=_sort_number;
@synthesize show_type=_show_type;
@synthesize home_number=_home_number;
@synthesize parent_id=_parent_id;
@synthesize is_leaf=_is_leaf;
@synthesize need_be_authorized=_need_be_authorized;
-(id)initWithChannelMO:(ChannelMO *)channel_mo{
    self=[super init];
    if(self){
        self.channel_id=channel_mo.a_channel_id;
        self.channel_name=channel_mo.a_channel_name;
        self.description=channel_mo.a_discription;
        self.sort_number=channel_mo.a_sort_number;
        self.show_type=(ShowType)channel_mo.a_show_type;
        self.home_number=channel_mo.a_home_number;
        self.parent_id=channel_mo.a_parent_id;
        self.is_leaf=(BOOL)channel_mo.a_is_leaf;
        self.need_be_authorized=(BOOL)channel_mo.a_authorize;
    }
    return self;
}
-(void)toChannelMO:(ChannelMO *)channelMO{
        channelMO.a_channel_id=self.channel_id;
        channelMO.a_channel_name=self.channel_name;
        channelMO.a_discription=self.description;
        channelMO.a_home_number=self.home_number;
        channelMO.a_is_leaf=[NSNumber numberWithBool: self.is_leaf];
        channelMO.a_parent_id=self.parent_id;
        channelMO.a_show_type=[NSNumber numberWithInt:self.show_type];
        channelMO.a_sort_number=self.sort_number;
        channelMO.a_authorize=[NSNumber numberWithInt:self.need_be_authorized];
}
@end
