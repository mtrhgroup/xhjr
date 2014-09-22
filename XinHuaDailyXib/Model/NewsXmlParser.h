//
//  NewsXmlParser.h
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDailyItem.h"
#import "NewsUserInfo.h"
#import "VersionInfo.h"
@interface NewsXmlParser : NSObject

+(NSArray*)ParseChannels:(NSString *) datastring;
+(NSArray*)ParseXDailyItems:(NSString *)datastring;
+(NSArray *)parseMoreXdailyItems:(NSString *)datastring;
+(XDailyItem*)ParseXDailyItem:(NSString *)datastring;
+(NSString *)CheckChannelsStatus:(NSString *)datastring;
+(NewsUserInfo *)ParseUserInfo:(NSString *)dataString;
+(VersionInfo *)ParseVersionInfo:(NSString *)dataString;
+(NSMutableArray *)ParseModifyActions:(NSString *)dataString;
@end
