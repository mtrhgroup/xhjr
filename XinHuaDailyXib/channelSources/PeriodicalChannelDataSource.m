//
//  PeriodicalChannelDataSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-28.
//
//

#import "PeriodicalChannelDataSource.h"
#import "NewsChannel.h"

@implementation PeriodicalChannelDataSource
- (id)init
{
    self = [super init];
    if (self) {
        super.channelheanderText=@"新华期刊";
    }
    return self;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNotification *note=[NSNotification notificationWithName:PeriodicalChannelTableDidSelectNewsNotification object:[self newsForIndexPath:indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

NSString *PeriodicalChannelTableDidSelectNewsNotification=@"PeriodicalChannelTableDidSelectNewsNotification";
@end
