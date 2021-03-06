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
#define kNotificationNewArticlesReceived @"notification_new_articles_received"
#define kNotificationLatestDailyReceived @"kNotificationLatestDailyReceived"
#define kNotificationLeftChannelsRefresh @"notification_left_channels_refresh"
#define kNotificationAppVersionReceived @"notification_app_version_received"
#define kNotificationBindSNSuccess @"kNotificationBindSNSuccess"
#define kNotificationShowPicChannel @"kNotificationShowPicChannel"
#define SXTErrorDomain @"com.xinhuanet.sxt"
#import "UIWindow+YzdHUD.h"
typedef enum {
    XDefultFailed = -1000,
    XBindingFailed,
    XNetworkLost,
    XParserFailed
}SXTErrorFailed;
#endif

#define VC_BG_COLOR ([UIColor colorWithRed:0x10/256.0  green:0x63/256.0 blue:0xC9/256.0 alpha:1])
#define HightLight_BG_COLOR ([UIColor colorWithRed:0x9B/256.0  green:0xC9/256.0 blue:0xFD/256.0 alpha:1])
#define Line_BG_COLOR ([UIColor colorWithRed:0x19/256.0  green:0x6C/256.0 blue:0xCC/256.0 alpha:1])