//
//  RemotePeriodicalItemSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-8-14.
//
//

#import "RemotePeriodicalItemSource.h"
#import "PeriodicalItem.h"
@implementation RemotePeriodicalItemSource
NSString *baseURL;
-(NSURL *)makeURLwith:(id)item{
    return  [NSURL URLWithString:[baseURL stringByAppendingString:((PeriodicalItem *)item).url]];
}
@end
