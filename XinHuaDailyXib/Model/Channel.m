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
@synthesize access_timestamp=_access_timestamp;
@synthesize receive_new_articles_timestamp=_receive_new_articles_timestamp;
@synthesize is_auto_cache=_is_auto_cache;
-(BOOL)has_new_articles{
    if(self.access_timestamp==nil)self.access_timestamp=[NSDate distantPast];
    if(self.receive_new_articles_timestamp==nil)self.receive_new_articles_timestamp=[NSDate distantPast];
    if([self.receive_new_articles_timestamp compare:self.access_timestamp]==NSOrderedDescending){
        return YES;
    }else{
        return NO;
    }
}
-(id)initWithChannelMO:(ChannelMO *)channel_mo{
    self=[super init];
    if(self){
        self.channel_id=channel_mo.a_channel_id;
        self.channel_name=channel_mo.a_channel_name;
        self.description=channel_mo.a_description;
        self.sort_number=[channel_mo.a_sort_number integerValue];
        self.show_type=channel_mo.a_show_type.intValue;
        self.home_number=[channel_mo.a_home_number integerValue];
        self.parent_id=channel_mo.a_parent_id;
        self.is_leaf=channel_mo.a_is_leaf.boolValue;
        self.need_be_authorized=channel_mo.a_authorize.boolValue;
        self.access_timestamp=channel_mo.a_access_timestamp;
        self.receive_new_articles_timestamp=channel_mo.a_receive_new_articles_timestamp;
        self.is_auto_cache=channel_mo.a_is_auto_cache.boolValue;
    }
    return self;
}
-(void)toChannelMO:(ChannelMO *)channelMO{
    channelMO.a_channel_id=self.channel_id;
    channelMO.a_channel_name=self.channel_name;
    channelMO.a_description=self.description;
    channelMO.a_home_number=[NSNumber numberWithInteger:self.home_number];
    channelMO.a_is_leaf=[NSNumber numberWithBool: self.is_leaf];
    channelMO.a_parent_id=self.parent_id;
    channelMO.a_show_type=[NSNumber numberWithInt:self.show_type];
    channelMO.a_sort_number=[NSNumber numberWithInteger:self.sort_number];
    channelMO.a_authorize=[NSNumber numberWithInt:self.need_be_authorized];
    //channelMO.a_access_timestamp=self.access_timestamp;
    //channelMO.a_receive_new_articles_timestamp=self.receive_new_articles_timestamp;
    channelMO.a_is_auto_cache=[NSNumber numberWithBool:self.is_auto_cache];
}
@end
@implementation ChannelsForHVC
@synthesize header_channel=_header_channel;
@synthesize other_channels=_other_channels;
@end