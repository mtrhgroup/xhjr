//
//  NewsCoreDataOperator.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import "NewsCoreDataOperator.h"
#import <CoreData/CoreData.h>
#import "SharedCoordinator.h"
#import "XDailyItem.h"
#import "DailyNews.h"
#import "Favor.h"
#import "Label.h"
#import "NewsChannel.h"
#import "Colors.h"

@implementation NewsCoreDataOperator
-(id)init{
    [self managedObjectContext];
    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil)
    {
		return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [[SharedCoordinator sharedInstance] persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


-(NSMutableArray*)GetImgNews
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"generate = %d",2];
    NSArray* channel= [self getObjectsByName: LabelName predicate:p   limited:1];
    __autoreleasing NSMutableArray* result =  [[NSMutableArray alloc] init];
    if(channel.count==1)
    {
        Label* channlImg= [channel objectAtIndex:0];
        NSString* channleid =  channlImg.channelID;
        NSPredicate* p2 = [NSPredicate predicateWithFormat:@"channelid = %@",channleid];
        NSArray* newss = [self searchObjectsByName:@"DailyNews" predicate:p2 sortKey:@"item_id" sortAscending:NO limited:10];
        
        for(DailyNews* news in newss)
        {
            XDailyItem* item = [XDailyItem XDailyItemFromDailyNews:news];
            [result addObject:item];
        }
        
        return result;
    }
    return nil;
}

-(NSMutableArray*)allChannels
{
    
//    NSArray* result = [self getObjectsByName:LabelName sortKey:@"sort" sortAscending:YES  limited:0];
//    __autoreleasing NSMutableArray*  newArray = [[NSMutableArray alloc] init];
//    
//    for(Label* label in result)
//    {
//        NewsChannel* channel = [NewsChannel  NewsChannelFromLabel:label];
//        channel.color=[Colors getColor];
//        [newArray addObject:channel];
//    }
//    return newArray;
    return nil;
}
-(void)saveChannel:(NewsChannel *)item
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
        data = [NSEntityDescription insertNewObjectForEntityForName:LabelName inManagedObjectContext: managedObjectContext];
    }
    data.name = item.title;
    data.level =item.level;
    data.des = item.description;
    data.sub = item.subscribe;
    data.channelID = item.channel_id;
    data.generate = item.generate;
    data.sort = item.sort;
    data.imgPath = item.imgPath;
}

-(NSMutableArray*)GetNewsByChannelID:(NSString *) channelId
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"channelid = %@",channelId];
    NSArray*  array = [self searchObjectsByName:@"DailyNews" predicate:p sortKey:@"item_id" sortAscending:NO limited:0];
    __autoreleasing NSMutableArray*  newArray =[[NSMutableArray alloc] init];
    for(DailyNews * daily in array)
    {
        XDailyItem * item = [XDailyItem XDailyItemFromDailyNews:daily];
        [newArray addObject:item];
    }
    return newArray;
}
- (void)saveXDailyItem:(XDailyItem*)item
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
        data = [NSEntityDescription insertNewObjectForEntityForName:@"DailyNews" inManagedObjectContext: managedObjectContext];
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


//entityname:表名
//predicate:参数
//sorAscending:排序
//limited:限制记录数量
- (NSArray *)getObjectsByName: (NSString*)entityName sortKey:(NSString*)sortKey sortAscending:(BOOL)sortAscending limited:(NSUInteger)limit
{
    return [self searchObjectsByName:entityName  predicate:nil sortKey:sortKey sortAscending:sortAscending limited:limit];
    
}
- (NSArray *)getObjectsByName: (NSString*)entityName predicate:(NSPredicate*)predict limited:(NSUInteger)limit
{
    return [self searchObjectsByName:entityName  predicate:predict sortKey:nil sortAscending:NO limited:limit];
}
- (NSArray*)searchObjectsByName: (NSString*)entityName  predicate:(NSPredicate *)predicate sortKey:(NSString*)sortKey sortAscending:(BOOL)sortAscending  limited:(NSUInteger)limit
{
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	if (limit > 0)
	{
		[request setFetchLimit:limit];
	}
	
	// If a predicate was passed, pass it to the query
	if(predicate != nil)
	{
		[request setPredicate:predicate];
	}
	
	// If a sort key was passed, use it for sorting.
	if(sortKey != nil)
	{
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];

	}
	
	NSError *error;

    NSArray* result = [managedObjectContext executeFetchRequest:request error:&error];
    
	return result;
}

- (BOOL)SaveDb
{
    BOOL result = NO;
    NSError *error;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges])
        {
            result = [managedObjectContext save:&error];
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


@end
