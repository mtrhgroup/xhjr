//
//  NewsFeedBackTask.h
//  CampusNewsLetter
//
//  Created by apple on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * notification : KShowToast           "显示后台任务的执行反馈"      userInfo:data  (NSString *) "执行反馈的文本信息"       
 */
@interface NewsFeedBackTask : NSObject
+(NewsFeedBackTask *)sharedInstance;
-(void)execute:(NSString *)authcode emailStr:(NSString *)emailStr contentStr:(NSString *)contentStr;
@end
