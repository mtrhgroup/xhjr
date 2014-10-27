//
//  UserDefaults.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-11.
//
//

#import "UserDefaults.h"

@implementation UserDefaults
@synthesize  outside_brightness_value;
@synthesize is_night_mode_on;
-(void)setHas_bind_device_to_server:(BOOL)has_bind_device_to_server{
    [[NSUserDefaults standardUserDefaults] setBool:has_bind_device_to_server forKey:@"has_bind_device_to_server"];
}
-(BOOL)has_bind_device_to_server{
   BOOL has_or_not=[[NSUserDefaults standardUserDefaults] boolForKey:@"has_bind_device_to_server"];
   return has_or_not;
}
-(void)setSn:(NSString *)sn{
    [[NSUserDefaults standardUserDefaults] setObject:sn forKey:@"sn"];
}
-(NSString *)sn{
   return [[NSUserDefaults standardUserDefaults] valueForKey:@"sn"];
}
-(void)setAppInfo:(AppInfo *)app_info{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:app_info];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"AppInfo"];
}
-(AppInfo *)appInfo{
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"AppInfo"];
    AppInfo *app_info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(app_info==nil)app_info=[[AppInfo alloc]init];
    return app_info;
}
-(void)setFont_size:(NSString *)fontSize{
    [[NSUserDefaults standardUserDefaults] setObject:fontSize forKey:@"fontSize"];
}
-(NSString *)font_size{
    NSString *fontSize=[[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"];
    if(fontSize==nil)return @"正常";
    else return fontSize;
}
-(void)setCache_article_number:(NSString *)cacheArticleNumber{
    [[NSUserDefaults standardUserDefaults] setObject:cacheArticleNumber forKey:@"cacheArticleNumber"];
}
-(NSString *)cache_article_number{
    NSString *numbers=[[NSUserDefaults standardUserDefaults] objectForKey:@"cacheArticleNumber"];
    if(numbers==nil)return @"20条";
    else return numbers;
}
-(BOOL)is_authorized{
    if(self.sn!=nil)return YES;
    else return NO;
}
@end
