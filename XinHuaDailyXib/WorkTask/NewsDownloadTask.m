//
//  NewsZipDownloadTask.m
//  CampusNewsLetter
//
//  Created by apple on 13-1-8.
//
//

#import "NewsDownloadTask.h"
#import "NewsChannel.h"
#import "XDailyItem.h"
#import "NewsXmlParser.h"
#import "NetStreamStatistics.h"
#import "ZipArchive.h"
#import "NewsZipReceivedReportTask.h"
#import "ModifyAction.h"
@implementation NewsDownloadTask
@synthesize db=_db;
-(id)initWithDB:(NewsDbOperator *)DbOperator{
    self = [super init];
    if (self) {
        self.db=DbOperator;
    }
    return self;
}
-(void)downloadXdaily:(XDailyItem *)xdaily{
    if([_db IsNewsInDb:xdaily]){
        [_db SaveDb];
        return;
    }
        
    NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[xdaily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    NSLog(@"url=%@",url);
    NSString* fileName = [url lastPathComponent];
    NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:30];
    request.downloadDestinationPath = filePath;
    request.userInfo= [NSDictionary dictionaryWithObjectsAndKeys:xdaily, @"item", nil];
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        int toAdd=(int)request.totalBytesRead;
        [[NetStreamStatistics sharedInstance]
         appendBytesToDictionary:toAdd];
        ZipArchive* zip = [[ZipArchive alloc] init];
        BOOL ret =  [zip UnzipOpenFile:filePath];
        if (ret)
        {
            if([zip UnzipFileTo:[filePath stringByDeletingPathExtension] overWrite:YES]){
                [_db addXDailyItem:xdaily];
                [_db SaveDb];
                [self reportUIXdailyloaded:xdaily];
                [NewsZipReceivedReportTask execute:xdaily];
            }
        }

    }else{
        NSLog(@"err %@",[err debugDescription]);
    }
}
-(void)downloadXdailyOfChannelId:(NSString *)channel_id topN:(NSString *)topN{
    NSString *url=[NSString stringWithFormat:KXdailyUrl,[UIDevice customUdid],topN,channel_id];
    NSLog(@"download channelwithurl :%@",url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        NSString *responseString = [request responseString];
        NSLog(@"%@",responseString);
        NSMutableArray * array = (NSMutableArray *)[NewsXmlParser ParseXDailyItems:responseString];
        for(XDailyItem *item in array){
            [self downloadXdaily:item];
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName: KAllTaskFinished object: self userInfo:nil];
    }
}
-(void)downloadIconOfChannel:(NewsChannel *)channel
{
    NSLog(@"%@ %@",channel.imgPath,channel.title);
    if(channel.imgPath==nil){
        return;
    }
    NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[channel.imgPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    NSString* fileName = [url lastPathComponent];
    NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return;
    }
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.downloadDestinationPath = [NSString stringWithFormat:@"%@%@", filePath,@"tmp"];
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        [[NSFileManager  defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@%@", filePath,@"tmp"]  toPath:filePath error:nil];
        channel.imgPath = fileName;
        [_db ModifyChannel:channel];
        [_db SaveDb];
        [self askUIToUpdate];
    }
}
-(void)downloadLatestXdaiyOfEachChannel: (NSArray *)channels
{
    if([channels count]==0)return;
    NSMutableString * tempString = [[NSMutableString alloc] init];
    for (NewsChannel * channel_subscribe in channels)
    {
        [tempString appendString:channel_subscribe.channel_id];
        [tempString appendString:@","];
    }
    NSString * sub_list_str=[tempString substringToIndex:tempString.length-1];
    NSString * url = [NSString stringWithFormat:KXdailyUrl,[UIDevice customUdid],@"5",sub_list_str];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        NSString *responseString = [request responseString];
        NSMutableArray * array = (NSMutableArray *)[NewsXmlParser ParseXDailyItems:responseString];
        for(XDailyItem *item in array){
            [self downloadXdaily:item];
        }
    }
}
-(void)downloadDataForMainview{
    if(busy)return;
    busy=YES;
    [self downloadChannelList];
    NSArray *temp_channel_subscribe=[_db ChannelsSubscrib];
    for(NewsChannel * channel in temp_channel_subscribe)
    {
        [self downloadIconOfChannel:channel];
    }
    
    for(NewsChannel *channel in temp_channel_subscribe)
    {
        [self downloadXdailyOfChannelId:channel.channel_id topN:@"5"];
    }
    busy=NO;
    NSLog(@"xdaily of special channel downloaded");
    //[self commitToServer];

}
-(void)downloadChannelList{
    NSString* url = [NSString stringWithFormat:KLabelUrl,[UIDevice customUdid]];
    NSLog(@"%@",url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        NSString *responseString = [request responseString];
        NSString *status= [NewsXmlParser CheckChannelsStatus:responseString];
        [[NSNotificationCenter defaultCenter] postNotificationName: NSSNExceptionNotification object:status];
        if([status isEqualToString:@"OK"]){
            NSArray * array = [NewsXmlParser ParseChannels:responseString];
            NSArray *channels=[_db allChannelsAndPicChannel];
            for (NewsChannel* channellocal in channels)
            {
                bool remoteHave=false;
                for(NewsChannel * channel in array)
                {
                    if([channellocal.channel_id isEqualToString:channel.channel_id])
                    {
                        if (channel.subscribe.intValue == 2) {
                            [_db ModifyChannel:channel];
                        }
                        remoteHave = true;
                        break;
                    }
                }
                if (!remoteHave) {
                    [_db DelChannelByChannelID:channellocal.channel_id];
                }
            }
            for(NewsChannel * channel in array)
            {
                [_db addChannel:channel];
                NSLog(@"%@  %d",channel.title,channel.generate.intValue);
            }
            [_db SaveDb];
            [[NSNotificationCenter defaultCenter] postNotificationName: UpdateChannelsNotification object: self userInfo:nil];
        }
    }
}
-(void)downloadMoreXdailyWithOldestXdailyId:(NSString *)oldestXdailyId channelId:(NSString *)channelId xdailyCount:(NSString *)xdailyCount{
    if([oldestXdailyId isEqualToString:@"0"])return;
    NSString *url=[NSString stringWithFormat:KMoreXdailys,oldestXdailyId,channelId,xdailyCount,[UIDevice customUdid]];
    NSLog(@"%@",url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        NSString *responseString = [request responseString];
        NSMutableArray * array = (NSMutableArray *)[NewsXmlParser parseMoreXdailyItems:responseString];
        for(XDailyItem *item in array){
            [self downloadXdaily:item];
            [_db SaveDb];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName: KAllTaskFinished
                                                            object: self userInfo:nil];
    }
}
-(BOOL)isPictureChannel:(NSString *)channel_id{
    NSArray *channels=[_db allChannels];
    for(NewsChannel *channel in channels){
        if([channel_id isEqualToString:channel.channel_id] && channel.generate.intValue==2){
            return YES;
        }
    }
    return NO;
}

bool busy=NO;
-(void)GetdatafromWebToDb
{
    NSLog(@"start download for main view");
    if(busy)return;
    busy=YES;
    [self downloadChannelList];
    NSArray *temp_channel_subscribe=[_db ChannelsSubscrib];
    for(NewsChannel * channel in temp_channel_subscribe)
    {
        [self downloadIconOfChannel:channel];
    }
    
    for(NewsChannel *channel in temp_channel_subscribe)
    {
       NSLog(@"start download channel :###%@",channel.title);
       [self downloadXdailyOfChannelId:channel.channel_id topN:@"5"];
    }
    busy=NO;
    NSLog(@"xdaily of special channel downloaded");
    [self commitToServer];
    [self delNewsWithSettingLimit];
}

-(void)clearfilesWithXdailys:(NSMutableArray *)array{
    for (XDailyItem *daily in array) {
        NSString* url = [daily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        NSString* fileName = [[url lastPathComponent] stringByDeletingPathExtension] ;
        NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
        NSLog(@"%@",filePath);
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:filePath error:nil];
        NSLog(@"filePath______==%@",filePath);
    }
}
-(void)delNewsWithSettingLimit{
    NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NSMutableArray* item2Delete=[_db DelNewsByRetainCount:[setdate intValue]];
    [_db SaveDb];
    [self clearfilesWithXdailys:item2Delete];
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory
                                                        object: self];
}
-(void)commitToServer{
    NSArray *channels_subscribe=[_db ChannelsSubscrib];
    if([channels_subscribe count]>0){
        NSMutableString * result = [[NSMutableString alloc] init];
        for (NewsChannel * channel_subscribe in channels_subscribe)
        {
            [result appendString:channel_subscribe.channel_id];
            [result appendString:@","];
        }
        NSString * sub_list_str=[result substringToIndex:result.length-1];
        NSString *sub_commit_url=[NSString stringWithFormat:KSubscribeCommitURL,[UIDevice customUdid],sub_list_str,[[UIDevice currentDevice] systemVersion],sxttype,sxtversion];
        NSLog(@"sub_commit_url = %@",sub_commit_url);
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:sub_commit_url]];
        [request startSynchronous];
        NSError *err=[request error];
        if(!err){
            NSString *responseString = [request responseString];
            NSLog(@"sub_commit_url = %@",responseString);
        }
    }
}

-(void)downloadExpressWithItemID:(NSString *)item_id{
    XDailyItem* tempItem =[AppDelegate.db GetXdailyByItemId: [NSNumber numberWithInt:item_id.intValue]];
    if(tempItem!=nil)
    {
        NSDictionary *d = [NSDictionary dictionaryWithObject:tempItem forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KExpressNewsOK object: self userInfo:d];
        return;
    }
    NSString*  itemurl =  [NSString stringWithFormat:KXdailyUrlOnlyOne,item_id,[UIDevice customUdid]];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:itemurl]];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:30];
    request.userInfo=[NSDictionary dictionaryWithObjectsAndKeys:item_id, @"item_id", nil];
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        NSString *item_id = [request.userInfo objectForKey:@"item_id"];
        NSString *responseString = [request responseString];
        XDailyItem * xdaily = [NewsXmlParser ParseXDailyItem:responseString];
        xdaily.item_id=[NSNumber numberWithInt:item_id.intValue];
        [self downloadXdaily:xdaily];        
    }
}
-(void)downloadItemIdsAndDelete{
    NSString* url = [NSString stringWithFormat:KDeleteAndUpdateNews,[UIDevice customUdid]];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        NSString *responseString = [request responseString];
        NSArray *actions=[NewsXmlParser ParseModifyActions:responseString];
        for(ModifyAction *action in actions){
            XDailyItem* item=[self.db GetXdailyByItemId:[NSNumber numberWithInt:action.f_id.intValue]];
            if(item!=nil){
                if([action.f_state isEqualToString:@"2"]){
                    [self.db DelNewsWithItemId:item.item_id];
                    [self.db SaveDb];
                    NSString* url = [item.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                    NSString* fileName = [[url lastPathComponent] stringByDeletingPathExtension] ;
                    NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
                    NSLog(@"%@",filePath);
                    NSFileManager *manager = [NSFileManager defaultManager];
                    [manager removeItemAtPath:filePath error:nil];
                }else if([action.f_state isEqualToString:@"1"]){
                    if(![action.f_inserttime isEqualToString:item.dateString])
                    [self.db ModifyNewsTime:action.f_inserttime itemid:[NSNumber numberWithInt:action.f_id.intValue]];
                    [self.db SaveDb];
                }
            }
        }
    }
}
-(void)askUIToUpdate{
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory  object: self];
}
-(void)reportUIXdailyloaded:(XDailyItem*) item{
//    if([self isPictureChannel:item.channelId]){
//        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdatePicture  object: self];
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory  object: self];
//    }
   
}
-(void)reportUIAllXdailyloaded{
   [[NSNotificationCenter defaultCenter] postNotificationName: KAllTaskFinished object: self];
}
NSString *NSSNExceptionNotification=@"NSSNExceptionNotification";
NSString *UpdateChannelsNotification=@"UpdateChannelsNotification";
@end
