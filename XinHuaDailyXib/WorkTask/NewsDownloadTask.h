//
//  NewsZipDownloadTask.h
//  CampusNewsLetter
//
//  Created by apple on 13-1-8.
//
//

#import "NewsDbOperator.h"
@interface NewsDownloadTask : NSObject
@property(nonatomic,retain)NewsDbOperator *db;
-(id)initWithDB:(NewsDbOperator *)DbOperator;
-(void)downloadChannelList;
-(void)downloadXdailyOfChannelId:(NSString *)channel_id topN:(NSString *)topN;
-(void)downloadIconOfChannel:(NewsChannel *)channel;
-(void)downloadLatestXdaiyOfEachChannel: (NSArray *)channels;
-(void)downloadMoreXdailyWithOldestXdailyId:(NSString *)oldestXdailyId channelId:(NSString *)channelId xdailyCount:(NSString *)xdailyCount;
-(void)downloadXdaily:(XDailyItem *)xdaily;
-(void)GetdatafromWebToDb;
-(void)commitToServer;
-(void)downloadItemIdsAndDelete;
@end
extern NSString *UpdateChannelsNotification;
extern NSString *NSSNExceptionNotification;