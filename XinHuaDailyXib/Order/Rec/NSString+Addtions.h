//
//  NSString+Addtions.h
//  YourOrder
//
//  Created by 胡世骞 on 14/12/1.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSString (Addtions)
- (NSString*)URLDecodedString;
-(NSString *)getFormatTimewithformat:(NSString *)format toformat:(NSString *)toformat;
-(NSString *)getToFormatTime;
@end
