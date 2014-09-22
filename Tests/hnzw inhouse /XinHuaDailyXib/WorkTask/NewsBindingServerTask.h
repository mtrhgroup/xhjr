//
//  NewsBindingServerTask.h
//  CampusNewsLetter
//
//  Created by apple on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
/*
 * notification : KBindlePhoneFailed   "绑定服务器失败"             userInfo:data       (NSString *) "绑定服务器失败的提示信息"
 *                KBindlePhoneOK       "绑定服务器成功"             userInfo:data       (NSString *) "服务器返回的当前用户类型信息" "old"｜"new"
 */
@interface NewsBindingServerTask : NSObject<ASIHTTPRequestDelegate>
+(void)execute;
@end
