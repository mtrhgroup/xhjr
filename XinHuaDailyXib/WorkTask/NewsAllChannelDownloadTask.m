//
//  NewsAllChannelDownloadTask.m
//  CampusNewsLetter
//
//  Created by apple on 13-1-8.
//
//

#import "NewsAllChannelDownloadTask.h"
#import "NewsXmlParser.h"
#import "NewsChannel.h"
#import "NewsDownloadTask.h"
@implementation NewsAllChannelDownloadTask
static bool busy=NO;
+(void)getChannelSubscrib{
    AppDelegate.channel_list_subscribe=nil;
    AppDelegate.channel_list_subscribe=[[AppDelegate.db ChannelsSubscrib] copy];
    NSLog(@" in block %d",[AppDelegate.channel_list_subscribe count]);
}
+(void)GetdatafromWebToDb
{
    NSLog(@"start download for main view");
    if(busy)return;
    busy=YES;
    [NewsDownloadTask downloadChannelList];
    NSLog(@"channel list downloaded");
    [self performSelectorOnMainThread:@selector(getChannelSubscrib) withObject:nil waitUntilDone:YES];
    NSLog(@" out block %d",[AppDelegate.channel_list_subscribe count]);
    NSArray *temp_channel_subscribe=AppDelegate.channel_list_subscribe;
    for(NewsChannel * channel in temp_channel_subscribe)
    {
        [NewsDownloadTask downloadIconOfChannel:channel];
    }
    for(NewsChannel *channel in temp_channel_subscribe)
    {
        switch ([channel.generate intValue]) {
            case 1:
            {
                [NewsDownloadTask downloadXdailyOfChannelId:channel.channel_id topN:@"5"];
                break;
            }
            case 2:
            {
                [NewsDownloadTask  downloadXdailyOfChannelId:channel.channel_id topN:@"5"];
                break;
            }
            case 0:
            {
                [NewsDownloadTask  downloadXdailyOfChannelId:channel.channel_id topN:@"5"];
                break;
            }
            default:
            {
                break;
            }
        }        
    }
    
    busy=NO;
    NSLog(@" busy %d",busy);
    [temp_channel_subscribe release];
    NSLog(@"xdaily of special channel downloaded");
    [self commitToServer];
}
+(void)commitToServer{
    if([AppDelegate.channel_list_subscribe count]>0){
        NSMutableString * result = [[NSMutableString alloc] init];
        for (NewsChannel * channel_subscribe in AppDelegate.channel_list_subscribe)
        {
            [result appendString:channel_subscribe.channel_id];
            [result appendString:@","];
        }
        NSString * sub_list_str=[result substringToIndex:result.length-1];
        [result release];
        NSString *sub_commit_url=[NSString stringWithFormat:KSubscribeCommitURL,[UIDevice customUdid],sub_list_str,[[UIDevice currentDevice] systemVersion]];
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
+(BOOL)isPictureChannel:(NSString *)channel_id{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate.channel_list=nil;
        AppDelegate.channel_list=[AppDelegate.db allChannels];
    });
    
    for(NewsChannel *channel in AppDelegate.channel_list){
        if([channel_id isEqualToString:channel.channel_id] && channel.generate.intValue==2){
            return YES;
        }
    }
    return NO;
}

+(void)execute{
    [self GetdatafromWebToDb];
}
@end
