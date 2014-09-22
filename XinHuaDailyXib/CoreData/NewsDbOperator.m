//
//  NewsDbOperator.m
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsDbOperator.h"
#import "Label.h"
#import "NewsChannel.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XDailyItem.h"
#import "DailyNews.h"
#import "Favor.h"
#import "Colors.h"
@implementation NewsDbOperator
@synthesize managedObjectContext=_managedObjectContext;
-(id)initWithContext:(NSManagedObjectContext *)context{
    if ((self = [super init]))
    {
        self.managedObjectContext = context;
    }
    return self;
}
- (BOOL)SaveDb
{
    BOOL result = NO;
    NSError *error;
    if (_managedObjectContext != nil)
    {
        if ([_managedObjectContext hasChanges])
        {
            result = [_managedObjectContext save:&error];
            if(!result)
            {
                // Handle error
                Logger(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(-1);  // Fail
            }
            Logger(@"Youlu SQLLite Saved");
        }
    }
    return YES;
}

-(void)addChannel:(NewsChannel *)item
{    
    NSPredicate* p = [NSPredicate predicateWithFormat:@"channelID = %@",item.channel_id];
    NSArray* result =  [self  getObjectsByName:LabelName predicate:p limited:1];
    Label *data;
    if (result.count == 1)
    {
        data = [result objectAtIndex:0];
    }
    else
    {
        data = [NSEntityDescription insertNewObjectForEntityForName:LabelName inManagedObjectContext: _managedObjectContext];
    }
    data.name = item.title;
    data.level =item.level;
    data.des = item.description;
    data.sub = item.subscribe;
    data.channelID = item.channel_id;
    data.generate = item.generate;
    data.sort = item.sort;
    data.imgPath = item.imgPath;
    data.homenum=item.homenum;
}
-(NSMutableArray*)allChannels
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"generate <> %d",2];
    NSArray* result = [self searchObjectsByName:LabelName predicate:p sortKey:@"sort" sortAscending:YES  limited:0];
    NSMutableArray*  newArray = [[NSMutableArray alloc] init];
    Colors *colors=[[Colors alloc]init];
    [colors reset];
    for(Label* label in result)
    {
        NewsChannel* channel = [NewsChannel  NewsChannelFromLabel:label];
        channel.color=[colors getColor];
        channel.imgArrow=[colors getImage];
        [colors next];
        [newArray addObject:channel];
    }
    return newArray;
}
-(NSMutableArray*)allChannelsAndPicChannel
{
    NSArray* result = [self getObjectsByName:LabelName sortKey:@"sort" sortAscending:YES  limited:0];
    NSMutableArray*  newArray = [[NSMutableArray alloc] init];
    Colors *colors=[[Colors alloc]init];
    [colors reset];
    for(Label* label in result)
    {
        NewsChannel* channel = [NewsChannel  NewsChannelFromLabel:label];
        channel.color=[colors getColor];
        channel.imgArrow=[colors getImage];
        [colors next];
        [newArray addObject:channel];
    }
    return newArray;
}
-(NSMutableArray*)ChannelsSubscrib
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"sub > 0"];
    NSArray* result = [self searchObjectsByName:LabelName predicate:p sortKey:@"sort" sortAscending:YES limited:0];
    NSMutableArray*  newArray = [[NSMutableArray alloc] init];
    
    for(Label* label in result)
    {
        NewsChannel* channel = [NewsChannel  NewsChannelFromLabel:label];
        [newArray addObject:channel];
        NSLog(@"%@",channel.sort);
    }
    return newArray;
}

- (void)addXDailyItem:(XDailyItem*)item
{
    
    NSDate* date = [NSDate dateFromString:item.dateString withFormat:@"yyyy－MM-dd"];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"key = %@",item.key];
    NSArray* result = [self  getObjectsByName:KDailyNewsData predicate:p   limited:1];
    DailyNews* data;
    if (result.count == 1)
    {
        data = [result objectAtIndex:0];
    }
    else
    {
        data = [NSEntityDescription insertNewObjectForEntityForName:@"DailyNews" inManagedObjectContext: _managedObjectContext];
        data.date = [NSNumber numberWithInt:[date timeIntervalSince1970]];
        data.read =[NSNumber numberWithBool:item.isRead];
    }
    data.newsDate = item.dateString;
    data.newsTitle = item.title;
    data.pageurl = item.pageurl;
    data.zipurl = item.zipurl;
    data.key = item.key;
    data.channelid = item.channelId;
    data.channeltitle= item.channelTitle;
    data.item_id = item.item_id;
    data.attachments = item.attachments;
    data.summary=item.summary;
    data.thumbnail=item.thumbnail;
    data.pn=item.pn;
}

- (DailyNews*)dailyNewsByDate:(NSTimeInterval)date
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"date = %f",date];
    NSArray* result = [self getObjectsByName:@"DailyNews" predicate:p limited:1];
    DailyNews* data = nil;
    if (result.count == 1)
    {
        data = [result objectAtIndex:0];
    }
    return data;
    
}
//entityname:表名
//predicate:参数
//sorAscending:排序
//limited:限制记录数量
- (NSArray*)searchObjectsByName: (NSString*)entityName  predicate:(NSPredicate *)predicate sortKey:(NSString*)sortKey sortAscending:(BOOL)sortAscending  limited:(NSUInteger)limit
{
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
	[request setEntity:entity];
	if (limit > 0)
	{
		[request setFetchLimit:limit];
	}

	if(predicate != nil)
	{
		[request setPredicate:predicate];
	}

	if(sortKey != nil)
	{
        if([sortKey isEqualToString:@"date"]){
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"item_id" ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, sortDescriptor2,nil];
		[request setSortDescriptors:sortDescriptors];
        }else{
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [request setSortDescriptors:sortDescriptors];
        }
	}
	
	NSError *error;
    NSArray* result = [_managedObjectContext executeFetchRequest:request error:&error];
    
	return result;
}


- (NSArray *)getObjectsByName: (NSString*)entityName sortKey:(NSString*)sortKey sortAscending:(BOOL)sortAscending limited:(NSUInteger)limit
{
    return [self searchObjectsByName:entityName  predicate:nil sortKey:sortKey sortAscending:sortAscending limited:limit];
    
}
- (NSArray *)getObjectsByName: (NSString*)entityName predicate:(NSPredicate*)predict limited:(NSUInteger)limit
{
    return [self searchObjectsByName:entityName  predicate:predict sortKey:nil sortAscending:NO limited:limit];
}

-(NSMutableArray*)GetNewsByChannelID:(NSString *) channelId
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"channelid = %@",channelId];
    NSArray*  array = [self searchObjectsByName:@"DailyNews" predicate:p sortKey:@"date" sortAscending:NO limited:0];
    NSMutableArray*  newArray =[[NSMutableArray alloc] init];
    for(DailyNews * daily in array)
    {
        XDailyItem * item = [XDailyItem XDailyItemFromDailyNews:daily];
        [newArray addObject:item];
    }
    return newArray;
}

-(NSMutableArray*)GetNewsByChannelID:(NSString *) channelId topN:(NSNumber *)topN
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"channelid = %@",channelId];
    NSArray*  array = [self searchObjectsByName:@"DailyNews" predicate:p sortKey:@"date" sortAscending:NO limited:[topN intValue]];
    NSMutableArray*  newArray =[[NSMutableArray alloc] init];
    for(DailyNews * daily in array)
    {
        XDailyItem * item = [XDailyItem XDailyItemFromDailyNews:daily];
        [newArray addObject:item];
    }
    return newArray;
}

-(NSMutableArray*) GetAllNews
{  
    NSArray* result = [self getObjectsByName: @"DailyNews" sortKey:@"date" sortAscending:NO  limited:0];
    NSMutableArray*  newArray = [[NSMutableArray alloc] init];    
    for(DailyNews* label in result)
    {
        XDailyItem* channel = [XDailyItem  XDailyItemFromDailyNews:label];
        [newArray addObject:channel];
        
    }
    return newArray;  
}

//获取所有Genertypy为0的新闻
-(NSMutableArray*) GetAllNewsExceptImgAndKuaiXun
{    
    NSPredicate* p = [NSPredicate predicateWithFormat:@"generate <> %d",2];
    NSArray* channels= [self getObjectsByName: LabelName predicate:p   limited:0];
    NSArray* result = [self getObjectsByName: @"DailyNews" sortKey:@"date" sortAscending:NO  limited:0];
    NSMutableArray*  newArray = [[NSMutableArray alloc] init];    
    for(DailyNews* news in result)
    {        
        for(Label* label in channels)
        {
            if([news.channelid isEqualToString:label.channelID])
            {
                XDailyItem* channel = [XDailyItem  XDailyItemFromDailyNews:news];
                [newArray addObject:channel];
                break;
            }
        }      
    }
    return newArray;
}

//获取所有Genertypy为0的新闻
-(NSMutableArray*) GetAllNewsSub
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"sub > 0 and generate <>2"];
    NSArray* channels= [self getObjectsByName: LabelName predicate:p   limited:0];
    NSArray* result = [self getObjectsByName: @"DailyNews" sortKey:@"date" sortAscending:NO  limited:0];
    NSMutableArray*  newArray = [[NSMutableArray alloc] init];
    for(DailyNews* news in result)
    {
        for(Label* label in channels)
        {
            if([news.channelid isEqualToString:label.channelID])
            {
                XDailyItem* channel = [XDailyItem  XDailyItemFromDailyNews:news];                
                [newArray addObject:channel];
                break;
            }
        }
    }
    return newArray;
}

-(void)ModifyChannelSubscribe:(NSString*) channelid sub:(NSNumber*)sub
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"channelID = %@", channelid];
    NSArray* result = [self getObjectsByName:@"Label" predicate:p limited:1];
    if(result.count==1)
    {
        Label* label = [result objectAtIndex:0];
        label.sub = sub;
    }
}

//修改用户排列顺序
-(void)ModifyChannelCustomOrder:(NSString*) channelid order:(NSNumber*)order{}

-(void)ModifyChannel:(NewsChannel*)channel
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"channelID = %@",channel.channel_id];
    NSArray* result = [self getObjectsByName:@"Label" predicate:p limited:1];
    if(result.count==1)
    {
        Label* label = [result objectAtIndex:0];
        label.imgPath = channel.imgPath;
        label.sub = channel.subscribe;
    }
    
}
-(void)ModifyDailyNews:(XDailyItem*) daily
{
    NSLog(@"title=%@,isread=%d",daily.key,daily.isRead);
    NSPredicate* p = [NSPredicate predicateWithFormat:@"key = %@",daily.key];
    NSArray* result = [self getObjectsByName:@"DailyNews" predicate:p limited:1];
    //daily.isRead=true;
    if (result.count == 1)
    {
        DailyNews* data = [result objectAtIndex:0];  
        data.read =  [NSNumber numberWithBool: daily.isRead ];
        NSLog(@"title=%@,%@",data.key,data.read);
    }
}

-(void)DelAllNews
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"generate <> %d",2];
    NSArray* channels= [self getObjectsByName: LabelName predicate:p   limited:0];  
    NSArray* result = [self getObjectsByName: @"DailyNews" sortKey:@"date" sortAscending:NO  limited:0];
    for(DailyNews* news in result)
    {        
        for(Label* label in channels)
        {
            if([news.channelid isEqualToString:label.channelID])
            {
                [_managedObjectContext deleteObject:news];
            }
        }  
    }   
}
-(NSArray*)GetNewsByLastDaysNumber:(int) dayCount
{
    NSMutableArray*  newArray = [[NSMutableArray alloc] init];
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * dayCount;
    NSDate *dayago = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];    
    NSNumber* number = [NSNumber numberWithInt:[dayago timeIntervalSince1970]];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"date < %@", number];
    NSArray* result = [self getObjectsByName: @"DailyNews" predicate:p   limited:0];
    for(DailyNews* label in result)
    {
        XDailyItem* channel = [XDailyItem  XDailyItemFromDailyNews:label];
        [newArray addObject:channel];
    }
    return newArray;
}
-(void)DelNewsByLastDaysNumber:(int) dayCount
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * dayCount;
    NSDate *dayago = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    NSNumber* number = [NSNumber numberWithInt:[dayago timeIntervalSince1970]];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"date < %@", number];
    NSArray* result = [self getObjectsByName: @"DailyNews" predicate:p   limited:0];
    for (id basket in result)
        [_managedObjectContext deleteObject:basket];
}

-(int)GetUnReadCountByChannelId:(NSString*) channelID
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"read = %d and channelid = %@",NO,channelID];
    NSArray*  array = [self searchObjectsByName:@"DailyNews" predicate:p sortKey:@"date" sortAscending:NO limited:0];
    return [array count];
}
-(int)GetUnReadCount
{ 
    NSPredicate* p1 = [NSPredicate predicateWithFormat:@"sub > 0 and generate <> %d",2];  
    NSArray* channels= [self getObjectsByName: LabelName predicate:p1   limited:0];
    if (!channels ||[channels count]==0) {
        return 0;
    }
    int result=0;
    for (Label* channel in channels) {
        int newsCountOfChannel = [self GetUnReadCountByChannelId:channel.channelID];
        result+=newsCountOfChannel;
    }
    return result;
}
-(NSMutableArray*)GetImgNews
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"generate = %d",2];
    NSArray* channels= [self getObjectsByName: LabelName predicate:p   limited:0];
    NSMutableArray* result =  [[NSMutableArray alloc] init];
    for(Label *channel in channels){
        NSString* channleid =  channel.channelID;
        NSPredicate* p2 = [NSPredicate predicateWithFormat:@"channelid = %@",channleid];
        NSArray* newss = [self searchObjectsByName:@"DailyNews" predicate:p2 sortKey:@"date" sortAscending:NO limited:5];
        for(DailyNews* news in newss)
        {
            XDailyItem* item = [XDailyItem XDailyItemFromDailyNews:news];
            [result addObject:item];
        }     
    }
    return result;
}

-(NSMutableArray*)GetKuaiXun

{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"generate = %d",1];
    NSArray* channels= [self getObjectsByName: LabelName predicate:p   limited:0];
    NSMutableArray* result =  [[NSMutableArray alloc] init];
    for(Label *channel in channels){
        NSString* channleid =  channel.channelID;
        NSPredicate* p2 = [NSPredicate predicateWithFormat:@"channelid = %@",channleid];
        NSArray* newss = [self searchObjectsByName:@"DailyNews" predicate:p2 sortKey:@"date" sortAscending:NO limited:5];
        for(DailyNews* news in newss)
        {
            XDailyItem* item = [XDailyItem XDailyItemFromDailyNews:news];
            [result addObject:item];
        }
    }
    return result;
}
-(NSMutableArray *)GetPushNews{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"pn=1"];
    NSArray* newss = [self searchObjectsByName:@"DailyNews" predicate:p sortKey:@"date" sortAscending:NO limited:0];
    NSMutableArray* result =  [[NSMutableArray alloc] init];
    for(DailyNews* news in newss)
    {
        XDailyItem* item = [XDailyItem XDailyItemFromDailyNews:news];
        [result addObject:item];
    }
    return result;
}
-(BOOL)IsNewsInDb:(XDailyItem*) news
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"item_id = %d",news.item_id.intValue];
    NSArray* result = [self  getObjectsByName:KDailyNewsData predicate:p   limited:1];    
    if (result.count == 1)
    {
        DailyNews* data = [result objectAtIndex:0];
        NSDate* date = [NSDate dateFromString:news.dateString withFormat:@"yyyy－MM-dd"];
        data.date = [NSNumber numberWithInt:[date timeIntervalSince1970]];
        data.newsDate=news.dateString;
        
        return true;
    }
    return false;
}
-(XDailyItem*)GetXdailyByItemId:(NSNumber*) itemid
{
    NSLog(@"GetXdailyByItemId %d",itemid.intValue);
    NSPredicate* p = [NSPredicate predicateWithFormat:@"item_id = %d", itemid.intValue];
    NSArray* result = [self  getObjectsByName:KDailyNewsData predicate:p   limited:1];
    if (result.count == 1)
    {
        return [XDailyItem XDailyItemFromDailyNews: [result objectAtIndex:0]];
    }
    return nil;
}

-(void)DelNewsWithItemId:(NSNumber*) itemid{
    NSLog(@"DelNewsWithItemId %d",itemid.intValue);
    NSPredicate* p = [NSPredicate predicateWithFormat:@"item_id = %d", itemid.intValue];
    NSArray* result = [self  getObjectsByName:KDailyNewsData predicate:p   limited:1];
    if (result.count == 1)
    {
        return [_managedObjectContext deleteObject:[result objectAtIndex:0]];
    }
}
-(void)ModifyNewsTime:(NSString *)timestr itemid:(NSNumber *)itemid{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"item_id = %d", itemid.intValue];
    NSArray* result = [self getObjectsByName:@"DailyNews" predicate:p limited:1];
    if (result.count == 1)
    {
        DailyNews* data = [result objectAtIndex:0];
        NSDate* date = [NSDate dateFromString:timestr withFormat:@"yyyy－MM-dd"];
        data.date = [NSNumber numberWithInt:[date timeIntervalSince1970]];
        data.newsDate=timestr;
    }
}
-(void)DelChannelByChannelID:(NSString*) channelID
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"channelID = %@", channelID];
    NSArray* result = [self getObjectsByName:LabelName predicate:p limited:1];
    if(result.count==1)
    {
        [_managedObjectContext deleteObject:[result objectAtIndex:0] ];
    }
}
-(NSMutableArray*)DelNewsByRetainCount:(int) count
{
    NSArray* array = [self allChannels];
    NSMutableArray* itemsToDelete = [[NSMutableArray alloc] init];
    if(!array||array.count==0) return nil;
    for (NewsChannel* channel in array)
    {    
        int countlocal =  [self GetCountByChannelId:channel.channel_id];
        if (countlocal<=count||countlocal==0)
        {
            continue;
        }
        else
        {
            int delcount = countlocal - count;        
            NSPredicate* p = [NSPredicate predicateWithFormat:@"channelid = %@",channel.channel_id];
            NSArray*  newss = [self searchObjectsByName:@"DailyNews" predicate:p sortKey:@"date" sortAscending:YES limited:0];
            NSLog(@"%d",delcount);
            for (int i =0; i<delcount; i++)
            {
                [itemsToDelete addObject: [XDailyItem XDailyItemFromDailyNews: [newss objectAtIndex:i]]];
                [_managedObjectContext deleteObject:[newss objectAtIndex:i]];
            }
        }
    }
    return itemsToDelete;  
}

-(int)GetCountByChannelId:(NSString*) channelID
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"channelid = %@",channelID];
    NSArray*  array = [self searchObjectsByName:@"DailyNews" predicate:p sortKey:@"date" sortAscending:NO limited:0];
    return [array count];
}

@end
