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
#define APP_KEY @"Y7rSoBs3iylgxe4zkLTaszzy"
#define kNotificationNewArticlesReceived @"notification_new_articles_received"
#define kNotificationChannelsReceived @"notification_channel_update"
#define kNotificationLatestDailyReceived @"kNotificationLatestDailyReceived"
#define kNotificationLeftChannelsRefresh @"notification_left_channels_refresh"
#define kNotificationAppVersionReceived @"notification_app_version_received"
#define kNotificationBindSNSuccess @"kNotificationBindSNSuccess"
#define kNotificationShowPicChannel @"kNotificationShowPicChannel"
#define VC_BG_COLOR ([UIColor colorWithRed:0xF0/256.0  green:0xEF/256.0 blue:0xF5/256.0 alpha:1])//去哪儿绿
#define SXTErrorDomain @"com.xinhuanet.sxt"

#import "UIWindow+YzdHUD.h"
typedef enum {
    XDefultFailed = -1000,
    XBindingFailed,
    XNetworkLost,
    XParserFailed
}SXTErrorFailed;
#endif
