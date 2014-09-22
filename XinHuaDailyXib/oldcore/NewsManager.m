//
//  NewsManager.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import "NewsManager.h"
#import "NewsChannel.h"
#import "XDailyItem.h"
#import "NewsDbOperator.h"
#import "NewsDownloadTask.h"
#import "NSThread+detachNewThreadSelectorWithObjs.h"
@implementation NewsManager
@synthesize delegate=_delegate;
@synthesize netOperator=_netOperator;
- (void)setDelegate:(id<NewsManagerDelegate>)newDelegate {
    if (newDelegate && ![newDelegate conformsToProtocol: @protocol(NewsManagerDelegate)]) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    _delegate = newDelegate;
}

-(void)fetchDataForMainView:(NewsChannel *)channel{
    if([channel isOld]){
        [self performSelectorInBackground:@selector(fetchDataForMainViewFormNetAndSaveToCoreData:) withObject:channel];
    }else{
        [self performSelectorInBackground:@selector(fetchDataForMainViewFromCoreData:) withObject:channel];
    }
        
}
-(void)fetchDataForMainViewFromCoreData:(NewsChannel *)channel{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NSMutableArray *channels=[db allChannels];
    for(NewsChannel *achannel in channels){
        achannel.items=[db GetNewsByChannelID:achannel.channel_id topN:achannel.homenum];
    }
    channel.items=[db GetImgNews];
    [channels insertObject:channel atIndex:0];
    [_delegate didReceiveNewsHeaders:channels];

}
-(void)fetchDataForMainViewFormNetAndSaveToCoreData:(NewsChannel *)channel{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NewsDownloadTask *task=[[NewsDownloadTask alloc] initWithDB:db];
    [task GetdatafromWebToDb];
    NSMutableArray *channels=[db allChannels];
    for(NewsChannel *achannel in channels){
        achannel.items=[db GetNewsByChannelID:achannel.channel_id topN:achannel.homenum];
    }
    channel.items=[db GetImgNews];
    [channels insertObject:channel atIndex:0];
    [_delegate didReceiveNewsHeaders:channels];
    [self postChannelNewsUpdateNotificationWithChannel:channel];
}
-(void)fetchAllChannels{
    [self performSelectorInBackground:@selector(fetchAllChannelsFromCoreData) withObject:nil];
}
-(void)fetchAllChannelsFromCoreData{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NSMutableArray *channels=[db allChannels];
    [_delegate didReceiveNewsHeaders:channels];
}
-(void)fetchaAllChannelsFromNetAndSaveToCoreData{
    NSArray *channels=[self fetchAllChannelsFromNet];
    [_delegate didReceiveNewsHeaders:[channels copy]];
    [self saveChannelsToCoreData:channels];
}
-(NSArray *)fetchAllChannelsFromNet{
    NewsNetOperator *_net=[[NewsNetOperator alloc]init];
    NSArray *items=[_net downloadChannelList];
    return items;
}
-(void)saveChannelsToCoreData:(NSArray *)channels{
    NewsCoreDataOperator *_db=[[NewsCoreDataOperator alloc]init];
    for(NewsChannel *channel in channels){
        [_db saveChannel:channel];
    }
    [_db SaveDb];
}
-(void)fetchMoreNewsItemsWithChannel:(NSString *)channel_id oldestXdailyId:(NSString *)oldestXdailyId xdailyCount:(NSString *)xdailyCount{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NewsDownloadTask *task=[[NewsDownloadTask alloc] initWithDB:db];
    [task downloadMoreXdailyWithOldestXdailyId:oldestXdailyId channelId:channel_id xdailyCount:xdailyCount];
    int topN=xdailyCount.intValue+10;
    NSMutableArray *items=[db GetNewsByChannelID:channel_id topN:[NSNumber numberWithInt:topN]];
    [_delegate didReceiveMoreNewsItems:items];
}

-(void)synchronizationAndFetchDataForMainViewInThead:(NewsChannel *)channel{
    [self performSelectorInBackground:@selector(fetchDataForMainViewFormNetAndSaveToCoreData:) withObject:channel];
}
-(void)synchronizationAndFetchNewsHeadersInThreadWithChannel:(NewsChannel *)channel{
        [self performSelectorInBackground:@selector(fetchNewsHeadersFromNetAndSaveToCoreDataWithChannel:) withObject:channel];   
}
-(void)fetchNewsHeadersFromCoreDataInThreadWithChannel:(NewsChannel *)channel{
    [self performSelectorInBackground:@selector(fetchNewsHeadersFromCoreDataWithChannel:) withObject:channel];
}

-(void)fetchNewsHeadersFromNetAndSaveToCoreDataWithChannel:(NewsChannel *)channel{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NewsDownloadTask *task=[[NewsDownloadTask alloc] initWithDB:db];
    [task downloadXdailyOfChannelId:channel.channel_id topN:@"10"];
    NSMutableArray *items=[db GetNewsByChannelID:channel.channel_id topN:[NSNumber numberWithInt:10]];
    [_delegate didReceiveNewsHeaders:[items copy]];
    [self postChannelNewsUpdateNotificationWithChannel:channel];
}
-(void)fetchNewsHeadersFromCoreDataWithChannel:(NewsChannel *)channel{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NSMutableArray *items=[db GetNewsByChannelID:channel.channel_id topN:[NSNumber numberWithInt:10]];
    [_delegate didReceiveNewsHeaders:items];
}

-(void)postChannelNewsUpdateNotificationWithChannel:(NewsChannel *)channel{
    NSNotification *note=[NSNotification notificationWithName:ChannelNewsUpdateNotification object:channel];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
NSString *ChannelNewsUpdateNotification=@"ChannelNewsUpdateNotification";

-(void)fetchNewsContentWithXdaily:(XDailyItem *)xdaily{
   [self setXdailyHasRead:xdaily];
    NSString *localPath=[xdaily localPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        [_delegate didReceiveNewsContent:xdaily];
    }else{
        [self performSelectorInBackground:@selector(fetchNewsContentFromNetWithXdaily:) withObject:xdaily];
    }
}
-(void)fetchNewsContentFromNetWithXdaily:(XDailyItem *)xdaily{
    NewsNetOperator *_net=[[NewsNetOperator alloc]init];
    BOOL success=[_net downloadXdaily:xdaily];
    if(success){
        [_delegate didReceiveNewsContent:xdaily];
    }

}
-(void)executeModifyActionsInThread{
    [self performSelectorInBackground:@selector(executeModifyActions) withObject:nil];
}
-(void)executeModifyActions{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NewsDownloadTask *task=[[NewsDownloadTask alloc] initWithDB:db];
    [task downloadItemIdsAndDelete];
}
-(void)setXdailyHasRead:(XDailyItem *)xdaily{
    NewsCoreDataOperator *_db=[[NewsCoreDataOperator alloc]init];
    xdaily.isRead=YES;
    [_db ModifyDailyNews:xdaily];
    [_db SaveDb];

    [self postXdailyChangedNotificationWithChannel];
}
-(void)postXdailyChangedNotificationWithChannel{
    NSNotification *note=[NSNotification notificationWithName:XdailyChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
NSString *XdailyChangedNotification=@"XdailyChangedNotification";

@end
