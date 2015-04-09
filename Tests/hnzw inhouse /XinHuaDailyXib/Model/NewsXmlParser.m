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

@implementation NewsXmlParser

+(NSMutableArray*)ParseChannels:(NSString *) datastring
{
   NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
     
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
        NSLog(@"%@",channel.subscribe);
        [result addObject:channel];
        [channel release];
        NSLog(@"解析channel %@",channel.title);
        item = [xml nextTagFrom:item];
        [f release];       
    }
    [xml release];
    
    return result;
}
+(NSString *)CheckChannelsStatus:(NSString *)datastring{
    NSIks* xml = [[[NSIks alloc] initWithString:datastring] autorelease];
  //  [datastring release];
    iks*  item =   xml.xmlObject;

    NSLog(@"%@",[xml nameFromNode:item]);
    //NSLog(@"%@",item);
    
    NSLog(@"xml retainCount %d",[xml retainCount]);
    NSString *statusNumber=[xml findAttribFrom:item attribname:@"sn_state"];
    NSLog(@"sn_state %@",statusNumber);
    NSLog(@"xml retainCount %d",[xml retainCount]);
    if([statusNumber isEqualToString:@"0"]){
        return @"OK";
    }else if([statusNumber isEqualToString:@"1"]){
        return @"OK";
    }else if([statusNumber isEqualToString:@"-1"]){
        return @"此SN过期！";
    }else if([statusNumber isEqualToString:@"-2"]){
        return @"此SN被禁用！";
    }else{
        return @"服务器发生错误！";
    }
    
}
+(NSMutableArray*)ParseXDailyItems:(NSString *)datastring
{
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
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
            
            [f release ];
            NSLog(@"dailyItem.item_id = %@",dailyItem.item_id);
            dailyItem.title  = [xml findValueFrom:citem nodeName:KTagTitle];
            dailyItem.zipurl = [xml findValueFrom:citem nodeName:KTagZipUrl];
            dailyItem.pageurl =  [xml findValueFrom:citem nodeName:KTagPageUrl];
            dailyItem.dateString = [xml findValueFrom:citem nodeName:KTagDate];
            dailyItem.attachments = [xml findValueFrom:citem nodeName:@"attachments"];
            dailyItem.key = [zip MD5String];
            dailyItem.isRead=NO;
            dailyItem.channelId = cid;
            dailyItem.channelTitle=ctitle;
            if([cid isEqualToString:@"17"]&&dailyItem.attachments==nil){
                
            }else{
                [result addObject:dailyItem];
            }
            [dailyItem release];
            citem = [xml nextTagFrom:citem];            
        }     
        item = [xml nextTagFrom:item];       
    } 
    [xml release];
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
        
        XDailyItem*  dailyItem = [[[XDailyItem alloc] init] autorelease];
        
        
        dailyItem.title  = [xml findValueFrom:citem nodeName:KTagTitle];
        NSLog(@"dailyItem.title = %@",dailyItem.title);
        dailyItem.zipurl = zip;
        dailyItem.pageurl =  [xml findValueFrom:citem nodeName:KTagPageUrl];
        dailyItem.dateString = [xml findValueFrom:citem nodeName:KTagDate];
        dailyItem.attachments = [xml findValueFrom:citem nodeName:@"attachments"];
        dailyItem.key = [zip MD5String];
        dailyItem.isRead=NO;
        dailyItem.channelId = [xml findValueFrom:citem nodeName:@"pid"];
        [xml release];
        return dailyItem;
        //dailyItem.attachments = 
        
        
    }
    [xml release]; 
    return nil;
    
}
+(NewsUserInfo *)ParseUserInfo:(NSString *)dataString{
    if(dataString.length<70)return nil;
    NSIks* xml = [[NSIks alloc] initWithString:dataString];
    iks*  citem  =  [xml firstTagFrom:xml.xmlObject];
    if (citem)
    {
        NewsUserInfo*  user_info = [[[NewsUserInfo alloc] init] autorelease];
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
        [xml release];
        return user_info;
    }
    [xml release];
    return nil;
}
@end
