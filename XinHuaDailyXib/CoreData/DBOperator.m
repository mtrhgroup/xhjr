//
//  DBOperator.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/9.
//
//

#import "DBOperator.h"
@implementation DBOperator
NSManagedObjectContext *_context;
static NSString * const E_CHANNEL = @"CHANNEL";
static NSString * const E_ARTICLE = @"ARTICLE";
-(id)initWithContext:(NSManagedObjectContext *)context{
    if(self=[super init]){
        _context=context;
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
    NSPredicate * p = [NSPredicate predicateWithFormat:@"channel_id = %@", channel.channel_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    E_Channel *e_channel;
    if([result count]>0){
        e_channel=[result objectAtIndex:0];
    }else{
        e_channel=[NSEntityDescription insertNewObjectForEntityForName:E_CHANNEL inManagedObjectContext:_context];
    }
    e_channel=channel;
}
-(NSArray *)fetchLeafChannelsWithTrunkChannel:(Channel *)trunk_channel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_show_location = %d ",Left];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    return result;
}
-(NSArray *)fetchTrunkChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_show_location = %d ",Left];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    return result;
}
-(Channel *)fetchADChannel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"a_show_location = %d",ADInContent];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return result[0];
    }
    return nil;
}
-(NSArray *)fetchNotificationArticles{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"is_push = %d",YES];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return result[0];
    }
    return nil;
}
-(void)removeAllChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    for(E_CHANNEL *channel in result){
        [_context deleteObject:channel];
    }
}

-(void)addArticle:(Article *)article{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"article_id = %@", article.article_id];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    E_Article *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
    }else{
        e_article=[NSEntityDescription insertNewObjectForEntityForName:E_ARTICLE inManagedObjectContext:_context];
    }
    e_article=article;
}
-(Article *)fetchHeaderArticleWithChannel:(Channel *)channel{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *  p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel.channel_id];
    NSSortDescriptor *sortPriorityDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:NO];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubish_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPriorityDescriptor,sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setFetchLimit:topN];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return result[0];
    }
}
-(NSArray *)fetchArticlesWithChannel:(Channel *)channel exceptArticle:(Article *)exceptArticle topN:(int)topN{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *  p
    if(exceptArticle!=nil){
        p= [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_article_id <>%@", channel.channel_id,exceptArticle.article_id];
    }else{
        p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel.channel_id];
    }
    NSSortDescriptor *sortPriorityDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:NO];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubish_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPriorityDescriptor,sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setFetchLimit:topN];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    return result;
}

-(NSArray *)fetchFavorArticles{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"is_favor = %d",YES];
    NSSortDescriptor *sortPriorityDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:NO];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubish_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPriorityDescriptor,sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    return result;
}
-(void)markArticleReadWithArticleID:(NSString *)articleID{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    E_Article *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
        e_article.a_is_read=[NSNumber numberWithBool:YES];
    }
}
-(void)markArticleFavorWithArticleID:(NSString *)articleID favor:(BOOL)favor{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    E_Article *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
        e_article.a_is_favor=[NSNumber numberWithBool:favor];
    }
    
}
-(void)deleteArticleWithArticleIDs:(NSString *)articleID{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"article_id = %@",articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    for(E_Article *article in result){
        [_context deleteObject:article];
    }
}
@end
