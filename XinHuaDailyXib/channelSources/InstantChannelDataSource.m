//
//  InstantChannelDataSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-28.
//
//

#import "InstantChannelDataSource.h"
#import "NewsChannel.h"
#import "InstantChannelDataSource.h"
@implementation InstantChannelDataSource
- (id)init
{
    self = [super init];
    if (self) {
        super.channelheanderText=@"新华快讯";
    }
    return self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsChannel *channel=[super newsForIndexPath:indexPath];
    if(channel.generate.intValue==2){
        NSNotification *note=[NSNotification notificationWithName:PictureChannelTableDidSelectNewsNotification object:channel];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }else{
        NSNotification *note=[NSNotification notificationWithName:InstantChannelTableDidSelectNewsNotification object:channel];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}

NSString *InstantChannelTableDidSelectNewsNotification=@"InstantChannelTableDidSelectNewsNotification";
NSString *PictureChannelTableDidSelectNewsNotification=@"PictureChannelTableDidSelectNewsNotification";


@end
