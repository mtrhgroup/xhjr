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
@implementation NewsDownloadTask

+(void)downloadXdaily:(XDailyItem *)xdaily{
    NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[xdaily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
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
            [zip UnzipFileTo:[filePath stringByDeletingPathExtension] overWrite:YES];
        }
        [zip release];
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppDelegate.db addXDailyItem:xdaily];
            [AppDelegate.db SaveDb];
            [self reportUIXdailyloaded:xdaily];
        });        
        [NewsZipReceivedReportTask execute:xdaily];
    }else{
        NSLog(@"err %@",[err debugDescription]);
    }
}
+(void)downloadXdailyOfChannelId:(NSString *)channel_id topN:(NSString *)topN{
    NSString *url=[NSString stringWithFormat:KXdailyUrl,[UIDevice customUdid],topN,channel_id];
    NSLog(@"%@",url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        NSString *responseString = [request responseString];
        NSMutableArray * array = (NSMutableArray *)[NewsXmlParser ParseXDailyItems:responseString];
        for(XDailyItem *item in array){
            NSLog(@"####%@",item.title);
            [self downloadXdaily:item];
            dispatch_async(dispatch_get_main_queue(), ^{                
                [AppDelegate.db SaveDb];
            });
        }
    }
}
+(void)downloadIconOfChannel:(NewsChannel *)channel
{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppDelegate.db ModifyChannel:channel];
            [AppDelegate.db SaveDb];
            [self askUIToUpdate];
        });       
    }
}
+(void)downloadLatestXdaiyOfEachChannel: (NSArray *)channels
{
    if([channels count]==0)return;
    NSMutableString * tempString = [[NSMutableString alloc] init];
    for (NewsChannel * channel_subscribe in channels)
    {
        [tempString appendString:channel_subscribe.channel_id];
        [tempString appendString:@","];
    }
    NSString * sub_list_str=[tempString substringToIndex:tempString.length-1];
    [tempString release];
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
+(void)downloadChannelList{
    NSString* url = [NSString stringWithFormat:KLabelUrl,[UIDevice customUdid]];
    NSLog(@"%@",url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request setShouldAttemptPersistentConnection:NO];
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        NSString *responseString = [request responseString];
        NSString *status= [NewsXmlParser CheckChannelsStatus:responseString];
        if([status isEqualToString:@"OK"]){
            NSArray * array = [NewsXmlParser ParseChannels:responseString];
            dispatch_async(dispatch_get_main_queue(), ^{
                AppDelegate.channel_list=[AppDelegate.db allChannels];
            });
             
            for (NewsChannel* channellocal in AppDelegate.channel_list)
            {
                bool remoteHave=false;
                for(NewsChannel * channel in array)
                {
                    if([channellocal.channel_id isEqualToString:channel.channel_id])
                    {
                        if (channel.subscribe.intValue == 2) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [AppDelegate.db ModifyChannel:channel];
                            });
                            
                        }
                        remoteHave = true;
                        break;
                    }
                }
                if (!remoteHave) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [AppDelegate.db DelChannelByChannelID:channellocal.channel_id];
                    });
                    
                }
            }
            for(NewsChannel * channel in array)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                     [AppDelegate.db addChannel:channel];
                });
                NSLog(@"%@  %d",channel.title,channel.generate.intValue);
               
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppDelegate.db SaveDb];
            });
            
        }
    }
}
+(BOOL)isPictureChannel:(NSString *)channel_id{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate.channel_list=[AppDelegate.db allChannels];
    });
    for(NewsChannel *channel in AppDelegate.channel_list){
        if([channel_id isEqualToString:channel.channel_id] && channel.generate.intValue==2){
            return YES;
        }
    }
    return NO;
}
+(void)askUIToUpdate{
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory  object: self];
}
+(void)reportUIXdailyloaded:(XDailyItem*) item{
    if([self isPictureChannel:item.channelId]){
        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdatePicture  object: self];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory  object: self];
    }
   
}
+(void)reportUIAllXdailyloaded{
   [[NSNotificationCenter defaultCenter] postNotificationName: KAllTaskFinished object: self];
}
@end
