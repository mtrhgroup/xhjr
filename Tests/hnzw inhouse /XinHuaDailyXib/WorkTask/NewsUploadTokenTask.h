//
//  NewsUploadTokenTask.h
//  CampusNewsLetter
//
//  Created by apple on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * notification : KShowToast           "显示后台任务的执行反馈"      userInfo:data  (NSString *) "执行反馈的文本信息"       
 */
@interface NewsUploadTokenTask : NSObject
+(NewsUploadTokenTask *)sharedInstance;
-(void)uploadToken:(NSString*)token;
-(void)clearBadgeOnServer;
@end
