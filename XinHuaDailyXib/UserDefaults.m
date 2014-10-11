//
//  UserDefaults.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-11.
//
//

#import "UserDefaults.h"

@implementation UserDefaults
static UserDefaults *_defaults=nil;
+(UserDefaults *)defaults{
    if(_defaults==nil){
        _defaults=[[UserDefaults alloc]init];
    }
    return _defaults;
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
@end
