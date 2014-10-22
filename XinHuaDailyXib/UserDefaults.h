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
@end
