//
//  NewsDownLoadZipWorkTask.h
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASINetworkQueue.h"
@class XDailyItem;
@protocol NewsDownloadFileFinishedCallBack  

-(void)NewsDownloadFileCompleted:(XDailyItem*) item;  
-(void)NewsDownloadFileErrCallBack:(XDailyItem*) item ;
-(void)AllZipFinished;

@end

@interface NewsDownLoadZipWorkTask : NSOperationQueue<ASIHTTPRequestDelegate>
{
     NSMutableDictionary     *_taskDiction;
     ASINetworkQueue * _queue;
}

@property (nonatomic,assign) id<NewsDownloadFileFinishedCallBack> delegate;
@property (nonatomic,retain) ASINetworkQueue * queue;
@property (nonatomic,retain) NSMutableDictionary     *taskDiction;

-(BOOL)addTask:(XDailyItem*) xdaily;
-(BOOL)addTasks:(NSMutableArray *)xdailys;


@end
