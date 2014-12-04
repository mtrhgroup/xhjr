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



@end
