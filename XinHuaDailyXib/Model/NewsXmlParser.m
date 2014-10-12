//
//  NewsXmlParser.m
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsXmlParser.h"
#import "NSIks.h"
#import "NewsChannel.h"
#import "XDailyItem.h"
#import "NewsDefine.h"
#import "ZipArchive.h"
#import "NewsUserInfo.h"
#import "AppInfo.h"
#import "Command.h"

@implementation NewsXmlParser

+(NSMutableArray*)ParseChannels:(NSString *) datastring
{
   NSMutableArray* result = [[NSMutableArray alloc] init];
     
    NSIks* xml = [[NSIks alloc] initWithString:datastring];
   // [datastring release];
     iks*  item =   [xml firstTagFrom:xml.xmlObject];
    while (item) 
    {
        NewsChannel *channel = [[NewsChannel alloc] init];
        channel.title = [xml findValueFrom:item nodeName:@"name"];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        channel.level = [f numberFromString:[xml findValueFrom:item nodeName:@"level"  ]];
        channel.channel_id = [xml findValueFrom:item nodeName:@"id" ];
        channel.description = [xml findValueFrom:item nodeName:@"description"];
        channel.subscribe=[f numberFromString:[xml findValueFrom:item nodeName:@"subscribe"]];
        channel.imgPath = [xml findValueFrom:item nodeName:@"iconurl"];
        channel.generate =[f numberFromString:[xml findValueFrom:item nodeName:@"generatetype"]];
        channel.sort = [f numberFromString:[xml findValueFrom:item nodeName:@"sort"]];
        channel.homenum=[f numberFromString:[xml findValueFrom:item nodeName:@"homenum"]];
        NSLog(@"%@",channel.subscribe);
        [result addObject:channel];
        NSLog(@"解析channel %@",channel.title);
        NSLog(@"%@",channel.generate);
        NSLog(@"%@",channel.imgPath);
        item = [xml nextTagFrom:item];     
    }
    return result;
}
+(NSString *)CheckChannelsStatus:(NSString *)datastring{
    NSIks* xml = [[NSIks alloc] initWithString:datastring];
    iks*  item =   xml.xmlObject;
    NSString *statusNumber=[xml findAttribFrom:item attribname:@"sn_state"];
    if([statusNumber isEqualToString:@"0"]){
        return @"授权码不存在!";
    }else if([statusNumber isEqualToString:@"1"]){
        return @"OK";
    }else if([statusNumber isEqualToString:@"-1"]){
        return @"授权码已过期!";
    }else if([statusNumber isEqualToString:@"-2"]){
        return @"授权码被禁用!";
    }else{
        return @"服务器发生错误！";
    }
}
+(NSMutableArray*)ParseXDailyItems:(NSString *)datastring
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSIks* xml = [[NSIks alloc] initWithString:datastring];
  //  [datastring release];
    iks*  item =   [xml firstTagFrom:xml.xmlObject];
    while (item) 
    {

      iks* citem = [xml firstTagFrom: item ];
        NSString* cid = [xml  findAttribFrom:item attribname:@"id"];
        NSString* ctitle=[xml findAttribFrom:item attribname:@"name"];
        while(citem)
        {
            
            NSString* title = [xml findValueFrom:citem nodeName:@"title"];
            NSLog(@"title = %@",title);
            NSString*  zip = [xml findValueFrom:citem nodeName:KTagZipUrl];
            XDailyItem*  dailyItem = [[XDailyItem alloc] init];
            
            
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            
            dailyItem.item_id=[f numberFromString:[xml findValueFrom:citem nodeName:@"id"]];
            NSLog(@"dailyItem.item_id = %@",dailyItem.item_id);
            dailyItem.title  = [xml findValueFrom:citem nodeName:KTagTitle];
            dailyItem.zipurl = [xml findValueFrom:citem nodeName:KTagZipUrl];
            dailyItem.pageurl =  [xml findValueFrom:citem nodeName:KTagPageUrl];
            NSString *tmpStr = [xml findValueFrom:citem nodeName:@"inserttime"];
            NSLog(@"%@",tmpStr);
            NSDateFormatter *df=[[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-M-d HH:mm:ss"];
            NSDate *date_a=[df dateFromString:tmpStr];
            NSString *outStr=[date_a stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSLog(@"%@",outStr);
            dailyItem.dateString=outStr;
            dailyItem.attachments = [xml findValueFrom:citem nodeName:@"attachments"];
            dailyItem.summary=[xml findValueFrom:citem nodeName:@"summary"];
            NSLog(@"summary=%@",dailyItem.summary);
            dailyItem.thumbnail=[xml findValueFrom:citem nodeName:@"thumbnail"];
            dailyItem.pn=[xml findValueFrom:citem nodeName:@"pn"];
            dailyItem.key = [zip MD5String];
            dailyItem.isRead=NO;
            dailyItem.channelId = cid;
            dailyItem.channelTitle=ctitle;
            if([cid isEqualToString:@"17"]&&dailyItem.attachments==nil){
                
            }else{
                [result addObject:dailyItem];
            }
            citem = [xml nextTagFrom:citem];            
        }     
        item = [xml nextTagFrom:item];       
    } 
    return result;
}
+(NSMutableArray *)parseMoreXdailyItems:(NSString *)datastring{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSIks* xml = [[NSIks alloc] initWithString:datastring];
    iks*  item =   [xml firstTagFrom:xml.xmlObject];
    while (item)
    {
        NSLog(@"%@",[xml nameFromNode:item]);
        NSString* title = [xml findValueFrom:item nodeName:@"title"];
        NSLog(@"title = %@",title);
        NSString*  zip = [xml findValueFrom:item nodeName:KTagZipUrl];
        XDailyItem*  dailyItem = [[XDailyItem alloc] init];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        dailyItem.item_id=[f numberFromString:[xml findValueFrom:item nodeName:@"id"]];
        NSLog(@"dailyItem.item_id = %@",dailyItem.item_id);
        dailyItem.title  = [xml findValueFrom:item nodeName:KTagTitle];
        dailyItem.zipurl = [xml findValueFrom:item nodeName:KTagZipUrl];
        dailyItem.pageurl =  [xml findValueFrom:item nodeName:KTagPageUrl];
        dailyItem.dateString = [xml findValueFrom:item nodeName:@"inserttime"];
        dailyItem.attachments = [xml findValueFrom:item nodeName:@"attachments"];
        dailyItem.summary=[xml findValueFrom:item nodeName:@"summary"];
        NSLog(@"summary=%@",dailyItem.summary);
        dailyItem.thumbnail=[xml findValueFrom:item nodeName:@"thumbnail"];
        dailyItem.pn=[xml findValueFrom:item nodeName:@"pn"];
        NSLog(@"thumbnail=%@",dailyItem.summary);
        dailyItem.key = [zip MD5String];
        dailyItem.isRead=NO;
        dailyItem.channelId = [xml findValueFrom:item nodeName:@"pid"];
        if([dailyItem.channelId isEqualToString:@"17"]&&dailyItem.attachments==nil){
            
        }else{
            [result addObject:dailyItem];
        }
        item = [xml nextTagFrom:item];
    }
    return result;
}
+(XDailyItem*)ParseXDailyItem:(NSString *)datastring
{
    NSIks* xml = [[NSIks alloc] initWithString:datastring];
   // [datastring release];
    iks*  citem  =  xml.xmlObject; 
    
    
    if (citem) 
    {
        NSString*  zip = [xml findValueFrom:citem nodeName:KTagZipUrl];
        
        XDailyItem*  dailyItem = [[XDailyItem alloc] init];
        
        dailyItem.item_id=[NSNumber numberWithInt:[[xml findValueFrom:citem nodeName:@"id"] intValue]];
        dailyItem.title  = [xml findValueFrom:citem nodeName:KTagTitle];
        NSLog(@"dailyItem.title = %@",dailyItem.title);
        dailyItem.zipurl = zip;
        dailyItem.pageurl =  [xml findValueFrom:citem nodeName:KTagPageUrl];
        dailyItem.dateString = [xml findValueFrom:citem nodeName:KTagDate];
        dailyItem.attachments = [xml findValueFrom:citem nodeName:@"attachments"];
        dailyItem.summary=[xml findValueFrom:citem nodeName:@"summary"];
        NSLog(@"summary=%@",dailyItem.summary);
        dailyItem.thumbnail=[xml findValueFrom:citem nodeName:@"thumbnail"];
        NSLog(@"thumbnail=%@",dailyItem.summary);
        dailyItem.pn=[xml findValueFrom:citem nodeName:@"pn"];
        dailyItem.key = [zip MD5String];
        dailyItem.isRead=NO;
        dailyItem.channelId = [xml findValueFrom:citem nodeName:@"pid"];
        return dailyItem;    
    }
    return nil;  
}
+(NewsUserInfo *)ParseUserInfo:(NSString *)dataString{
    if(dataString.length<70)return nil;
    NSIks* xml = [[NSIks alloc] initWithString:dataString];
    iks*  citem  =  [xml firstTagFrom:xml.xmlObject];
    if (citem)
    {
        NewsUserInfo*  user_info = [[NewsUserInfo alloc] init];
        user_info.sn=[xml findValueFrom:citem nodeName:KSn];
        user_info.description=[xml findValueFrom:citem nodeName:KDescription];
        user_info.name=[xml findValueFrom:citem nodeName:KName];
        user_info.sex=[xml findValueFrom:citem nodeName:KSex];
        user_info.company=[xml findValueFrom:citem nodeName:KCom];
        user_info.phone=[xml findValueFrom:citem nodeName:KPhone];
        user_info.email=[xml findValueFrom:citem nodeName:KEmail];
        if([[xml findValueFrom:citem nodeName:KEnabled] isEqualToString:@"True"])user_info.enabled=YES;
        else user_info.enabled=NO;
        user_info.enddate=[xml findValueFrom:citem nodeName:KEndDate];
        user_info.updateTime=[xml findValueFrom:citem nodeName:KUpdateTime];
        return user_info;
    }
    return nil;
}
+(AppInfo *)ParseVersionInfo:(NSString *)dataString{
    if(dataString.length<70)return nil;
    NSIks* xml = [[NSIks alloc] initWithString:dataString];
    iks*  citem  = xml.xmlObject;
    if (citem)
    {
        NSLog(@"%@",[xml nameFromNode:citem]);
        __autoreleasing AppInfo*  version_info = [[AppInfo alloc] init];
        version_info.snState=[xml findValueFrom:citem nodeName:@"sn_state"];
        NSLog(@"sn_state=%@",version_info.snState);
        version_info.snMsg=[xml findValueFrom:citem nodeName:@"sn_msg"];
        version_info.groupTitle=[xml findValueFrom:citem nodeName:@"group_title"];
        version_info.groupSubTitle=[xml findValueFrom:citem nodeName:@"group_sub_title"];
        version_info.startImgUrl=[xml findValueFrom:citem nodeName:@"startimage"];
        version_info.gid=[xml findValueFrom:citem nodeName:@"gid"];
        return version_info;
    }
    return nil;
}
+(NSMutableArray *)ParseModifyActions:(NSString *)dataString{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSIks* xml = [[NSIks alloc] initWithString:dataString];
    iks*  item =   [xml firstTagFrom:xml.xmlObject];
    while (item)
    {
        NSLog(@"%@",[xml nameFromNode:item]);
        Command*  action = [[Command alloc] init];
        action.f_id = [xml findValueFrom:item nodeName:@"F_ID"];
        action.f_inserttime=[xml findValueFrom:item nodeName:@"F_InsertTime"];
        action.f_state=[xml findValueFrom:item nodeName:@"F_State"];
        [result addObject:action];
        item = [xml nextTagFrom:item];
    }
    return result;
}
@end
