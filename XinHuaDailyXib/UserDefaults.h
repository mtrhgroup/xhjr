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
@property(nonatomic,strong)NSString *font_size;
@property(nonatomic,strong)NSString *cache_article_number;
@property(readonly,assign)BOOL is_authorized;
@property(nonatomic,assign)BOOL has_bind_device_to_server;
@property(nonatomic,assign)float outside_brightness_value;
@property(nonatomic,assign)BOOL is_night_mode_on;
@end
