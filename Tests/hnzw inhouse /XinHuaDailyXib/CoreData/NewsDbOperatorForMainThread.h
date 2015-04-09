//
//  NewsDbOperatorForMainThread.h
//  CampusNewsLetter
//
//  Created by apple on 13-1-9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Label;
@class NewsChannel;

@class XDailyItem;
@class DailyNews;

@class NewsFavor;
@class Favor;
@interface NewsDbOperatorForMainThread : NSObject{
   NSManagedObjectContext *managedObjectContext;
}

- (BOOL)SaveDb;
- (NSArray*)getObjectsByName: (NSString*)entityName sortKey:(NSString*)sortKey sortAscending: (BOOL)sortAscending limited:(NSUInteger)limit;
- (NSArray*)getObjectsByName: (NSString*)entityName predicate:(NSPredicate*)predict limited:(NSUInteger)limit;

//增加期刊
-(void) addChannel:(NewsChannel*) item;
//获得所有期刊
-(NSMutableArray*)allChannels;
//获得已订阅的期刊
-(NSMutableArray*)ChannelsSubscrib;
//修改订阅状态，yes为订阅，no取消订阅
-(void)ModifyChannelSubscribe:(NSString*) channelid sub:(NSNumber*)sub;
-(void)ModifyChannel:(NewsChannel*)channel;
//删除频道
-(void)DelChannelByChannelID:(NSString*) channelID;

//按照channelId获得news
-(NSMutableArray*)GetNewsByChannelID:(NSString*) channelId;
//增加news
- (void)addXDailyItem:(XDailyItem*)item;
//根据日期获得news
//- (DailyNews*)dailyNewsByDate:(NSTimeInterval)date;
-(void)ModifyDailyNews:(XDailyItem*) daily;
-(NSMutableArray*) GetAllNews;
-(void)DelAllNews;
-(int)GetUnReadCountByChannelId:(NSString*) channelID;
-(int)GetUnReadCount;
-(NSMutableArray*)GetImgNews;
-(NSMutableArray*)GetKuaiXun;
-(NSMutableArray*) GetAllNewsExceptImgAndKuaiXun;
//判断是否xdaily是否在数据库中
-(BOOL)IsNewsInDb:(XDailyItem*) news ;
-(XDailyItem*)GetXdailyByItemId:(NSNumber*) itemid;

//返回所有订阅频道的news
-(NSMutableArray*) GetAllNewsSub;
-(NSMutableArray*)DelNewsByRetainCount:(int) count;

@end
