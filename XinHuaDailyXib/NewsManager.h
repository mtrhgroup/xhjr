//
//  NewsManager.h
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import <Foundation/Foundation.h>
#import "NewsManagerDelegate.h"
#import "NewsCoreDataOperator.h"
#import "NewsNetOperator.h"
@class PictureNews;
@class XDailyItem;
@interface NewsManager : NSObject
@property (weak, nonatomic) id <NewsManagerDelegate> delegate;
@property (strong,nonatomic) NewsNetOperator *netOperator;
-(void)fetchAllChannels;
-(void)synchronizationAndFetchNewsHeadersInThreadWithChannel:(NewsChannel *)channel;
-(void)fetchNewsHeadersFromCoreDataInThreadWithChannel:(NewsChannel *)channel;
-(void)fetchNewsContentWithXdaily:(XDailyItem *)xdaily;
-(void)fetchDataForMainView:(NewsChannel *)channel;
-(void)synchronizationAndFetchDataForMainViewInThead:(NewsChannel *)channel;
-(void)fetchMoreNewsItemsWithChannel:(NSString *)channel_id oldestXdailyId:(NSString *)oldestXdailyId xdailyCount:(NSString *)xdailyCount;
-(void)executeModifyActionsInThread;
@end
extern NSString *ChannelNewsUpdateNotification;
extern NSString  *XdailyChangedNotification;