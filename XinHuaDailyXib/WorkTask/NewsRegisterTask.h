//
//  NewsRegisterTask.h
//  CampusNewsLetter
//
//  Created by apple on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
/*
 * notification : KShowToast           "显示后台任务的执行反馈"      userInfo:data  (NSString *) "执行反馈的文本信息"
 *                KBindleSnOK          "授权码注册成功"           
 */
@interface NewsRegisterTask : NSObject<ASIHTTPRequestDelegate>
+(NewsRegisterTask *)sharedInstance;
-(BOOL)isRegistered;
-(void)execute:(NSString *)authCode;
-(void)getUserInfo:(NSString *)authCode;
-(void)regWith:(NSString *)username company:(NSString *)company telphone:(NSString *)telphone;
@end
