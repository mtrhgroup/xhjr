//
//  NewsLabel.m
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//
//  NewsChannel.m
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsChannel.h"
#import "Label.h"

@implementation NewsChannel
@synthesize channel_id = _channel_id, title = _title, description = _description, level=_level,subscribe=_subscribe, custom_order=_custom_order,  imgPath = _imgPath,generate = _generate ,sort=_sort,timestamp=_timestamp,color=_color,imgArrow=_imgArrow, items=_items,homenum=_homenum;



-(void)stampTime{
   self.timestamp=[NSDate date];
}
-(BOOL)isOld{
    NSDate *now=[NSDate date];
    NSTimeInterval date1=[now timeIntervalSinceReferenceDate];
    NSTimeInterval date2=[_timestamp timeIntervalSinceReferenceDate];
    long interval=date1-date2;
    long const fiveminutes=60*5;
    NSLog(@"now:%f  stamp:%f",date1,date2);
    if(interval>fiveminutes){
        return YES;
    }else{
        return NO;
    }
}
+(NewsChannel*)NewsChannelFromLabel:(Label*) label;

{
    NewsChannel *channel = [[NewsChannel alloc] init] ;
    channel.channel_id = label.channelID;
    channel.title = label.name;
    channel.description = label.des;
    channel.level = label.level;
    channel.subscribe = label.sub ;
    channel.custom_order = label.order;
    channel.imgPath = label.imgPath;
    channel.generate = label.generate;
    channel.sort = label.sort;
    channel.homenum=label.homenum;
    return channel;
}
@end
