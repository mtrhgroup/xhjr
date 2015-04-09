//
//  DBOperator.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/9.
//
//

#import "DBOperator.h"
@interface DBOperator()
@property(strong,nonatomic)NSManagedObjectContext *context;
@end
@implementation DBOperator
@synthesize context=_context;
static NSString * const E_CHANNEL = @"E_CHANNEL";
static NSString * const E_ARTICLE = @"E_ARTICLE";
static NSString * const E_KEYWORD = @"E_KEYWORD";
-(id)initWithContext:(NSManagedObjectContext *)context{
    if(self=[super init]){
        self.context=context;
    }
    return self;

}

-(BOOL)save{
    BOOL result=NO;
    NSError *error;
    if(_context!=nil){
        if([_context hasChanges]){
            result=[_context save:&error];
            if(!result){
                NSLog(@"数据库操作失败！%@",error);
                exit(-1);
            }
        }
    }
    return YES;
}
-(void)addChannel:(Channel *)channel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel.channel_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    ChannelMO *e_channel;
    if([result count]>0){
        e_channel=[result objectAtIndex:0];
    }else{
        e_channel=[NSEntityDescription insertNewObjectForEntityForName:E_CHANNEL inManagedObjectContext:_context];
    }
    [channel toChannelMO:e_channel];
}
-(void)removeChannel:(Channel *)channel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel.channel_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
         [_context deleteObject:result[0]];
    }
}
-(void)addKeyword:(Keyword *)keyword{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_KEYWORD inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_keyword_id = %@", keyword.keyword_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    KeywordMO *e_keyword;
    if([result count]>0){
        e_keyword=[result objectAtIndex:0];
    }else{
        e_keyword=[NSEntityDescription insertNewObjectForEntityForName:E_KEYWORD inManagedObjectContext:_context];
    }
    [keyword toKeywordMO:e_keyword];
}
-(NSArray *)fetchKeywords{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_KEYWORD inManagedObjectContext:_context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_keyword_sort" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *keywords=[NSMutableArray array];
    for(KeywordMO *kmo in result){
        [keywords addObject:[[Keyword alloc] initWithKeywordMO:kmo]];
    }
    return keywords;
}

-(NSArray *)fetchAllChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort_number" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *trunk_channels=[NSMutableArray array];
    for(ChannelMO *amo in result){
        [trunk_channels addObject:[[Channel alloc] initWithChannelMO:amo]];
        NSLog(@"%d",amo.a_show_type.intValue);
    }
    return trunk_channels;
}
-(NSArray *)fetchLeafChannelsWithTrunkChannel:(Channel *)trunk_channel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_parent_id = %@ ",trunk_channel.channel_id];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort_number" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *leaf_channels=[NSMutableArray array];
    for(ChannelMO *amo in result){
        [leaf_channels addObject:[[Channel alloc] initWithChannelMO:amo]];
    }
    NSLog(@"%@",trunk_channel.channel_id);
    return leaf_channels;
}

-(NSArray *)fetchTrunkChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_parent_id = %@ ",@"0"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort_number" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *trunk_channels=[NSMutableArray array];
    for(ChannelMO *amo in result){
        [trunk_channels addObject:[[Channel alloc] initWithChannelMO:amo]];
        NSLog(@"%d",amo.a_show_type.intValue);
    }
    return trunk_channels;
}
-(NSDate *)markChannelAccessTimeStampWithChannel:(Channel *)channel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel.channel_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    ChannelMO *e_channel;
    if([result count]>0){
        e_channel=[result objectAtIndex:0];
        e_channel.a_access_timestamp=[NSDate date];
    }
    
    return e_channel.a_access_timestamp;
}
-(NSDate *)markChannelReceiveNewArticlesTimeStampWithChannelID:(NSString *)channel_id{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    ChannelMO *e_channel;
    if([result count]>0){
        e_channel=[result objectAtIndex:0];
        e_channel.a_receive_new_articles_timestamp=[NSDate date];
    }
    return e_channel.a_receive_new_articles_timestamp;
}
-(NSArray *)fetchHomeChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_is_leaf = %d && a_home_number > %d",YES,0];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort_number" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *home_channels=[NSMutableArray array];
    for(ChannelMO *amo in result){
        [home_channels addObject:[[Channel alloc] initWithChannelMO:amo]];
    }
    return home_channels;
}
-(NSArray *)fetchTopicChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_parent_id = %d",-3];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort_number" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *topic_channels=[NSMutableArray array];
    for(ChannelMO *amo in result){
        [topic_channels addObject:[[Channel alloc] initWithChannelMO:amo]];
    }
    return topic_channels;
}
-(Channel *)fetchADChannel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_parent_id = %d",-1];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        Channel *ad_channel=[[Channel alloc] initWithChannelMO:result[0]];
        return ad_channel;
    }
    
    return nil;
}
-(Channel *)fetchMRCJChannel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_channel_id = %@",@"388"];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        Channel *ad_channel=[[Channel alloc] initWithChannelMO:result[0]];
        return ad_channel;
    }
    
    return nil;
}

-(NSArray *)fetchArticlesThatIsPushed{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"is_push = %d",YES];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[NSMutableArray array];
    for(ArticleMO *amo in result){
        [articles addObject:[[Article alloc] initWithArticleMO:amo]];
    }
    return articles;
}
-(Channel *)fetchPicChannel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_home_number < %d",0];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        Channel *ad_channel=[[Channel alloc] initWithChannelMO:result[0]];
        return ad_channel;
    }
    
    return nil;
}
-(NSArray *)fetchArticlesThatIncludeCoverImage{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_cover_image_url<>%@",0];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[NSMutableArray array];
    for(ArticleMO *amo in result){
        [articles addObject:[[Article alloc] initWithArticleMO:amo]];
    }
    return articles;
}
-(void)removeAllChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    for(ChannelMO*channel in result){
        [_context deleteObject:channel];
    }
}

-(void)addArticle:(Article *)article{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@", article.article_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    ArticleMO *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
    }else{
        e_article=[NSEntityDescription insertNewObjectForEntityForName:E_ARTICLE inManagedObjectContext:_context];
    }
    [article toArticleMO:e_article];
}
-(Article *)fetchHeaderArticle{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *  p=  [NSPredicate predicateWithFormat:@"a_cover_image_url<>%@",nil];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setFetchLimit:1];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return [[Article alloc] initWithArticleMO:result[0]];
    }else{
        return nil;
    }
}
-(NSArray *)fetchOtherArticlesWithExceptArticle:(Article *)exceptArticle topN:(NSInteger)topN{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *  p;
    if(exceptArticle!=nil){
        p= [NSPredicate predicateWithFormat:@"a_article_id <>%@",exceptArticle.article_id];
    }else{
        p= nil;
    }
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setFetchLimit:topN];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[NSMutableArray array];
    for(ArticleMO *amo in result){
        [articles addObject:[[Article alloc] initWithArticleMO:amo]];
    }
    return articles;
}
-(Article *)fetchHeaderArticleWithChannel:(Channel *)channel{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *  p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_cover_image_url<>%@", channel.channel_id,nil];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setFetchLimit:1];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return [[Article alloc] initWithArticleMO:result[0]];
    }else{
        return nil;
    }
}
-(NSArray *)fetchArticlesWithChannel:(Channel *)channel exceptArticle:(Article *)exceptArticle topN:(NSInteger)topN{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *  p;
    if(exceptArticle!=nil){
        p= [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_article_id <>%@", channel.channel_id,exceptArticle.article_id];
    }else{
        p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel.channel_id];
    }
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setFetchLimit:topN];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[NSMutableArray array];
    for(ArticleMO *amo in result){
        [articles addObject:[[Article alloc] initWithArticleMO:amo]];
    }
    return articles;
}
-(NSArray *)fetchArticlesWithTag:(NSString *)tag{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *p=  [NSPredicate predicateWithFormat:@"a_key_words CONTAINS[cd] %@", tag];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[NSMutableArray array];
    for(ArticleMO *amo in result){
        [articles addObject:[[Article alloc] initWithArticleMO:amo]];
    }
    return articles;
}
-(NSArray *)fetchDailyArticlesWithChannel:(Channel *)channel date:(NSString *)date{
    if(date.length==0)return [NSArray new];
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_publish_date BEGINSWITH[cd] %@", channel.channel_id,date];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[NSMutableArray array];
    for(ArticleMO *amo in result){
        [articles addObject:[[Article alloc] initWithArticleMO:amo]];
    }
    return articles;
}
-(NSString *)queryPreviousAvailableDateWithChannel:(Channel *)channel date:(NSString *)date{
    NSString *complete_date=[NSString stringWithFormat:@"%@ 00:00:00",date];
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_publish_date < %@", channel.channel_id,complete_date];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return [((ArticleMO *)result[0]).a_publish_date substringToIndex:10];
    }else{
        return @"";
    }
}
-(NSString *)queryNextAvailableDateWithChannel:(Channel *)channel date:(NSString *)date{
    NSString *complete_date=[NSString stringWithFormat:@"%@ 23:59:59",date];
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_publish_date > %@", channel.channel_id,complete_date];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return [((ArticleMO *)result[0]).a_publish_date substringToIndex:10];
    }else{
        return @"";
    }
}
-(NSString *)queryLatestAvailableDateWithChannel:(Channel *)channel{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel.channel_id];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        NSLog(@"##%@",((ArticleMO *)result[0]).a_publish_date);
        return [((ArticleMO *)result[0]).a_publish_date substringToIndex:10];
    }else{
        return @"";
    }
}
-(NSArray *)fetchFavorArticles{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_is_collected = %d",YES];
    NSSortDescriptor *sortPriorityDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPriorityDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    NSMutableArray *articles=[NSMutableArray array];
    for(ArticleMO *amo in result){
        [articles addObject:[[Article alloc] initWithArticleMO:amo]];
    }
    return articles;
}
-(void)markArticleReadWithArticleID:(NSString *)articleID{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    ArticleMO *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
        e_article.a_is_read=[NSNumber numberWithBool:YES];
    }
}
-(void)markArticleFavorWithArticleID:(NSString *)articleID is_collected:(BOOL)is_collected{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    ArticleMO *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
        e_article.a_is_collected=[NSNumber numberWithBool:is_collected];
    }
}
-(void)markArticleLikeWithArticleID:(NSString *)articleID likeNumber:(NSNumber *)likeNumber{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    ArticleMO *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
        e_article.a_is_like=[NSNumber numberWithBool:YES];
        e_article.a_like_number=likeNumber;
    }
}
-(void)markArticleCommentsNumberWithArticleID:(NSString *)articleID commentsNumber:(NSNumber *)commentsNumber{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    ArticleMO *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
        e_article.a_comments_number=commentsNumber;
    }
}
-(BOOL)doesArticleExistWithArtilceID:(NSString *)articleID{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@",articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return YES;
    }else{
        return NO;
    }
}
-(Article *)fetchArticleWithArticleID:(NSString *)articleID{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@",articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return [[Article alloc]initWithArticleMO:result[0]];
    }else{
        return nil;
    }
}
-(void)updateArticleTimeWithArticleID:(NSString *)articleID newTime:(NSString *)newTime{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@",articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    for(ArticleMO *article in result){
        article.a_publish_date=newTime;
    }
}
-(void)deleteArticleWithArticleID:(NSString *)articleID{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"a_article_id = %@",articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    for(ArticleMO *article in result){
        [_context deleteObject:article];
    }
}
@end
