//
//  NSString+Addtions.m
//  YourOrder
//
//  Created by 胡世骞 on 14/12/1.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "NSString+Addtions.h"

@implementation NSString (Addtions)

- (NSString *)URLEncodedString
{
    NSString* urlString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, nil, CFSTR("~!@$&*()_+-=':;?,./ "), kCFStringEncodingUTF8));
    
    return urlString;
}

- (NSString*)URLDecodedString
{
    NSString* ret = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (ret == nil) {
        return self;
    }
    return ret;
}

static NSDateFormatter *dateFormatter;

-(NSString *)getFormatTimewithformat:(NSString *)format toformat:(NSString *)toformat
{
    if (dateFormatter == nil) {
        dateFormatter=[[NSDateFormatter alloc]init];
    }
    [dateFormatter setDateFormat:format];
    NSDate *date=[dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:toformat];
    
    return [dateFormatter stringFromDate:date];
}


-(NSString *)getToFormatTime
{
    if (dateFormatter == nil) {
        dateFormatter=[[NSDateFormatter alloc]init];
    }
    [dateFormatter setDateFormat:WITHFORMAT];
    NSDate *date=[dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:TOFORMAT];
    
    return [dateFormatter stringFromDate:date];
}
-(NSString *)forNowTime
{
    NSString *forNow;
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:WITHFORMAT];
    NSDate *d=[date dateFromString:self];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSCalendar *chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit | NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *DateComponent = [chineseClendar components:unitFlags fromDate:d toDate:dat options:0];
    
    NSInteger diffHour = [DateComponent hour];
    
    NSInteger diffMin    = [DateComponent minute];
    
//    NSInteger diffSec   = [DateComponent second];
    
    NSInteger diffDay   = [DateComponent day];
    
    NSInteger diffMon  = [DateComponent month];
    
    NSInteger diffYear = [DateComponent year];
    
    if (diffYear>0) {
        forNow=[NSString stringWithFormat:@"%ld 年前",(long)diffYear];
    }else if(diffMon>0){
        forNow=[NSString stringWithFormat:@"%ld 月前",(long)diffMon];
    }else if(diffDay>0){
        forNow=[NSString stringWithFormat:@"%ld 天前",(long)diffDay];
    }else if(diffHour>0){
        forNow=[NSString stringWithFormat:@"%ld 小时前",(long)diffHour];
    }else if(diffMin>0){
        forNow=[NSString stringWithFormat:@"%ld 分钟前",(long)diffMin];
    }else{
        //            _forNow=[NSString stringWithFormat:@"%ld 秒前",(long)diffSec];
        forNow=[NSString stringWithFormat:@"刚刚"];
    }
    return forNow;
}

@end
