//
//  NewsDbOperator.h
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Label;
@class NewsChannel;

@class XDailyItem;
@class DailyNews;

@class NewsFavor;
@class Favor;
@interface NewsDbOperator : NSObject{
    NSString*   databasepath;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSLock  *lock;
}

@property (nonatomic, readonly)NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain)NSString*  databasepath;
//初始化数据库
//此方法在系统加载时调用
- (id)initWithFile:(NSString*)dbPath;
//保存数据库，本函数在退出程序以及需要修改数据库实例时调用，数据库本身在内存中有一个demo
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
//修改用户排列顺序
//-(void)ModifyChannelCustomOrder:(NSString*) channelid order:(NSNumber*)order;

//
//-(void)AddNewsFavor:(NewsFavor *) favor;

////增加收藏
//-(void)AddFavor:(Favor*)favor;
//-(void)AddFavor:(Favor*)favor;
////删除多个收藏
//-(void)DelAllFavor:(NSMutableArray*) array;
////删除单个收藏
//-(void)DelFavor:(Favor*) favor;

////获得所有收藏
//-(NSArray*)AllFavor;


//-(NSArray*)GetNewsByLastDaysNumber:(int) dayCount;
//-(void)DelNewsByLastDaysNumber:(int) dayCount;

-(NSMutableArray*)DelNewsByRetainCount:(int) count;


@end