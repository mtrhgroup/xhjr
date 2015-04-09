//
//  NewsDownloadExpreesTask.h
//  CampusNewsLetter
//
//  Created by apple on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * notification : KExpressNewsOK           "快讯准备完毕"      userInfo:data  (NSString *) "执行反馈的文本信息"
 *                KExpressNewsError        "快讯准备失败"      userInfo:data  (XDailyItem*) "快讯对象" 
 */
@interface NewsDownloadExpreesTask : NSObject
+(NewsDownloadExpreesTask *)sharedInstance;
-(void)execute:(NSString *)item_id;
@end
