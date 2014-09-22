//
//  UnsubscribeChannelDataSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-28.
//
//

#import "UnsubscribeChannelDataSource.h"
#import "NewsChannel.h"

@implementation UnsubscribeChannelDataSource
- (id)init
{
    self = [super init];
    if (self) {
        super.channelheanderText=@"未订阅";
    }
    return self;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNotification *note=[NSNotification notificationWithName:UnsubscribeChannelTableDidSelectNewsNotification object:[self newsForIndexPath:indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

NSString *UnsubscribeChannelTableDidSelectNewsNotification=@"UnsubscribeChannelTableDidSelectNewsNotification";

@end

