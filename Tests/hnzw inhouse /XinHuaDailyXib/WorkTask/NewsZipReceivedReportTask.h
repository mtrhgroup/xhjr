//
//  NewsZipReceivedReportTask.h
//  CampusNewsLetter
//
//  Created by apple on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsZipReceivedReportTask : NSObject
+(void)execute:(XDailyItem *)daily;
@end
