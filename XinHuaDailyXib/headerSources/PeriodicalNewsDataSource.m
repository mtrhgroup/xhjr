//
//  PeriodicalNewsDataSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-28.
//
//

#import "PeriodicalNewsDataSource.h"
#import "XDailyItem.h"

@implementation PeriodicalNewsDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNotification *note=[NSNotification notificationWithName:PeriodicalNewsTableDidSelectNewsNotification object:[super newsForIndexPath:indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
NSString *PeriodicalNewsTableDidSelectNewsNotification=@"PeriodicalNewsTableDidSelectNewsNotification";
@end
