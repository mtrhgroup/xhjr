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
-(NSString *)bytes_lost_of_cell_this_month{
    NSDictionary *byteslostDic= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
    int bytesLostOfThisMonth=((NSString *)[byteslostDic objectForKey:[self currentMonth]]).intValue;
    if(bytesLostOfThisMonth==0){
        return @"无";
    }else{
        return [self bytesFormater:bytesLostOfThisMonth];
    }
}
-(NSString *)bytes_lost_of_cell_last_month{
    NSDictionary *byteslostDic= [[NSUserDefaults standardUserDefaults] objectForKey:@"CELLBYTES"];
    int cellOflastMonth=((NSString *)[byteslostDic objectForKey:[self lastMonth]]).intValue;
    if(cellOflastMonth==0){
        return @"无";
    }else{
        return [self bytesFormater:cellOflastMonth];
    }
}
-(NSString *)bytes_lost_of_wifi_this_month{
    NSDictionary *byteslostDic= [[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIBYTES"];
    int bytesLostOfThisMonth=((NSString *)[byteslostDic objectForKey:[self currentMonth]]).intValue;
    if(bytesLostOfThisMonth==0){
        return @"无";
    }else{
        return [self bytesFormater:bytesLostOfThisMonth];
    }
}
-(NSString *)bytes_lost_of_wifi_lost_month{
    NSDictionary *byteslostDic= [[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIBYTES"];
    int wifiOflastMonth=((NSString *)[byteslostDic objectForKey:[self lastMonth]]).intValue;
    if(wifiOflastMonth==0){
        return @"无";
    }else{
        return [self bytesFormater:wifiOflastMonth];
    }
}

-(NSString *)currentMonth{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%d",components.month];
}
-(NSString *)lastMonth{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components=[calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    int last=0;
    if(components.month>1)last=components.month-1;
    else
        last=12;
    return [NSString stringWithFormat:@"%d",last];
}
-(NSString *)bytesFormater:(int)bytes{
    NSString * str=@"";
    NSLog(@"bytesFormater %d",bytes);
    if(bytes>1024*1024){
        str=[NSString stringWithFormat:@"%.2f M",bytes/(1024.0*1024.0)];
    }else if(bytes>1024){
        str=[NSString stringWithFormat:@"%.2f K",bytes/1024.0];
    }else{
        str=[NSString stringWithFormat:@"%d B",bytes];
    }
    return str;
}

@end
