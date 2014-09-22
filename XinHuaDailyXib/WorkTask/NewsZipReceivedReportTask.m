//
//  NewsZipReceivedReportTask.m
//  CampusNewsLetter
//
//  Created by apple on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsZipReceivedReportTask.h"
#import "XDailyItem.h"

@implementation NewsZipReceivedReportTask
+(void)execute:(XDailyItem *)daily{
    NSString *zipreceived_report_url=[NSString stringWithFormat:KReportZipDownloadUrl,[UIDevice customUdid],daily.channelId,daily.item_id,[[UIDevice currentDevice] systemVersion],sxttype,sxtversion];
    NSLog(@"#### %@",zipreceived_report_url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:zipreceived_report_url]];
    [request startSynchronous];
}

@end
