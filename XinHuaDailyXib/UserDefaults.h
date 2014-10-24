//
//  UserDefaults.h
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-11.
//
//

#import <Foundation/Foundation.h>
#import "AppInfo.h"
@interface UserDefaults : NSObject
@property(nonatomic,strong)NSString *sn;
@property(nonatomic,strong)AppInfo *appInfo;
@property(nonatomic,strong)NSString *fontSize;
@property(nonatomic,strong)NSString *cacheArticleNumber;
@property(readonly,assign)BOOL is_authorized;
@property(nonatomic,assign)BOOL has_bind_device_to_server;
@end
