//
//  LocalPeriodicalItemSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-8-14.
//
//

#import "LocalPeriodicalItemSource.h"
#import "PeriodicalItem.h"
@implementation LocalPeriodicalItemSource
@synthesize baseURL=_baseURL;
-(NSURL *)makeURLwith:(id)item{
    return  [NSURL fileURLWithPath:[_baseURL stringByAppendingString:((PeriodicalItem *)item).url]];
}
@end
