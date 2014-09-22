//
//  NewsDownLoadZipWorkTask.m
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsDownLoadZipWorkTask.h"
#import "XDailyItem.h"
#import "ASIHTTPRequest.h"
#import "ZipArchive.h"
#import "XinhuaAppDelegate.h"
#import "NewsDbOperator.h"
#import "Reachability.h"
#import "NewsChannel.h"
#import "ASINetworkQueue.h"
#import "NetStreamStatistics.h"
#import "NewsZipReceivedReportTask.h"
@implementation NewsDownLoadZipWorkTask

@synthesize delegate;
@synthesize taskDiction = _taskDiction;
@synthesize queue=_queue;
int _count=0;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.taskDiction = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
    
}


-(BOOL)addTask:(XDailyItem*) xdaily
{
    if (![self queue])
    {
        [self setQueue:[[[ASINetworkQueue alloc] init] autorelease] ] ;
        [self queue].shouldCancelAllRequestsOnFailure = NO;
        [self queue].maxConcurrentOperationCount=1;
        [[self queue] go]; 
       
    }
    NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[xdaily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    
    NSString* md5Key = [url MD5String];
    NSString* fileName = [url lastPathComponent];
    NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
    NSLog(@"save %@",xdaily.title);
    if ([ AppDelegate.db IsNewsInDb:xdaily] )
    {
        return NO;
    }
    [self.taskDiction setValue:[NSNumber numberWithBool:YES] forKey:md5Key];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:30];
     request.downloadDestinationPath = filePath;
    request.userInfo= [NSDictionary dictionaryWithObjectsAndKeys:xdaily, @"item", nil];
    request.delegate=self;    
   [[self queue] addOperation:request];
    return YES;
     
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    
     NSLog(@"requestFinished");
     XDailyItem *xdaily = [request.userInfo objectForKey:@"item"];
    NSLog(@"requestFinished  AAA");
    NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[xdaily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];    
    
    NSString* fileName = [url lastPathComponent];
    NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
    int toAdd=(int)request.totalBytesRead;
    [[NetStreamStatistics sharedInstance] appendBytesToDictionary:toAdd];
     NSLog(@"requestFinished  BBB");
    ZipArchive* zip = [[ZipArchive alloc] init];
    BOOL ret =  [zip UnzipOpenFile:filePath];
    NSLog(@"requestFinished  ccc");
    if (ret)
    {
        [zip UnzipFileTo:[filePath stringByDeletingPathExtension] overWrite:YES];
    } 
     NSLog(@"requestFinished  ddd");
    NSString * zipfilename=[request.url lastPathComponent];
    NSLog(@"zip file name :%@",zipfilename);
    [NewsZipReceivedReportTask execute:xdaily];
    NSLog(@"save %@",xdaily.title);
    [AppDelegate.db addXDailyItem:xdaily];
    [AppDelegate.db SaveDb];   
            NSLog(@"notification updatepic");
    if([self isPictureChannel:xdaily.channelId]){
        NSLog(@"notification updatepic");
        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdatePicture
                                                            object: self];
    }else{
        NSLog(@"notification update");
        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory
                                                            object: self];
    }
    
    
    [zip release];
    _count--;
    if(_count==0)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: KAllTaskFinished
                                                            object: self];
    }
    NSLog(@"requestRetainCount %d",[request retainCount]);
    //[request clearDelegatesAndCancel];
    //[request release];
    [self removeRequestFromQueue:request];
    NSLog(@"requestRetainCount %d",[request retainCount]);
}
-(void)requestFailed:(ASIHTTPRequest *)request{
     NSLog(@"requestFinished  RRR");
    _count--;
    if(_count==0){
        //            [[NSNotificationCenter defaultCenter] postNotificationName: KAllTaskFinished
        //                                                                object: self];
    }
    NSError *error = [request error];
    NSLog(@"error = %@",[error localizedDescription]);
    //[self doneLoadingTableViewData];
    //xdaily.title = [error localizedDescription];
    //        if(self.delegate&&[self.delegate conformsToProtocol:@protocol(NewsDownloadFileFinishedCallBack)]){
    //            [delegate NewsDownloadFileErrCallBack:xdaily];
    //        }
    //[request clearDelegatesAndCancel];
    //[request release];
    [self removeRequestFromQueue:request];
}
-(void)removeRequestFromQueue:(ASIHTTPRequest *)request{
    XDailyItem *request_item=[request.userInfo objectForKey:@"item"];
    for (ASIHTTPRequest *r in [_queue operations]) {
        XDailyItem *item = [r.userInfo objectForKey:@"item"];
        if ([item.item_id isEqualToNumber:request_item.item_id]) {
            [r clearDelegatesAndCancel];
            //[r release];
        }
    }
}

-(BOOL)isPictureChannel:(NSString *)channel_id{
    NSMutableArray * channels=[AppDelegate.db allChannels];
    for(NewsChannel *channel in channels){
        if([channel_id isEqualToString:channel.channel_id] && channel.generate.intValue==2){
            return YES;
        }
    }
    return NO;
}

-(BOOL)addTasks:(NSMutableArray *)xdailys{
    _count =  xdailys.count;
    for(int i=0;i<[xdailys count];i++){

          if(! [self addTask:(XDailyItem*) [xdailys objectAtIndex:i]])
          {
              _count--;
          }
      
    }
    if(_count==0)
        return false;
    return  true;
}

-(void)dealloc{
    [_queue release];
    _queue = nil;
    [super dealloc];
}
@end
