//
//  GlobalVariables.h
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-15.
//
//

#ifndef XinHuaDailyXib_GlobalVariables_h
#define XinHuaDailyXib_GlobalVariables_h
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define lessiOS7 [[[UIDevice currentDevice] systemVersion] floatValue]<7.0
#define kHeightOfTopScrollView  35.0f
#define APP_KEY @"koZZjgSLNSOc5Gdp6WNpCA3i"
#define KUserDefaultAuthCode  @"AuthCode"
#define kNotificationMessage @"notification_message"
#define kNotificationArticleReceived @"notification_article_received"
#define kNotificationChannelsUpdate @"notification_channel_update"
#define kNotificationAppVersionReceived @"notification_app_version_received"
#define KSettingChange @"fontchange"
#define KDisplayMode @"DisplayMode"
#define SXTErrorDomain @"com.xinhuanet.sxt"
#import "UIWindow+YzdHUD.h"
typedef enum {
    XDefultFailed = -1000,
    XBindingFailed,
    XNetworkLost,
    XParserFailed
}SXTErrorFailed;
#endif
