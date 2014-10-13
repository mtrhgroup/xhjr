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
    Channel *e_channel;
    if([result count]>0){
        e_channel=[result objectAtIndex:0];
    }else{
        e_channel=[NSEntityDescription insertNewObjectForEntityForName:E_CHANNEL inManagedObjectContext:_context];
    }
    e_channel=channel;
}
-(NSArray *)fetchLeafChannelsWithTrunkChannel:(Channel *)trunk_channel{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"parent_id = %d ",trunk_channel.channel_id];
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
    NSPredicate* p = [NSPredicate predicateWithFormat:@"is_leaf = %d ",NO];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"a_sort" ascending:NSOrderedAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    return result;
}
-(NSArray *)fetchHomeChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"is_leaf = %d and parent_id = %@",YES,@"0"];
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
    NSPredicate* p = [NSPredicate predicateWithFormat:@"parent_id = %d",-1];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return result[0];
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
    if([result count]>0){
        return result[0];
    }
    return nil;
}
-(NSArray *)fetchArticlesThatIncludeCoverImage{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate* p = [NSPredicate predicateWithFormat:@"cover_image_url = %d",0];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return result;
    }
    return nil;
}
-(void)removeAllChannels{
    NSEntityDescription * e_channel_desc = [NSEntityDescription entityForName:E_CHANNEL inManagedObjectContext:_context];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_channel_desc];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    for(Channel *channel in result){
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
    Article *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
    }else{
        e_article=[NSEntityDescription insertNewObjectForEntityForName:E_ARTICLE inManagedObjectContext:_context];
    }
    e_article=article;
}
-(Article *)fetchHeaderArticleWithChannel:(Channel *)channel{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *  p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@ and cover_image_url<>%@", channel.channel_id,nil];
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"publish_date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    [frq setFetchLimit:1];
    [frq setSortDescriptors:sortDescriptors];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return result[0];
    }else{
        return nil;
    }
}
-(NSArray *)fetchArticlesWithChannel:(Channel *)channel exceptArticle:(Article *)exceptArticle topN:(int)topN{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate *  p;
    if(exceptArticle!=nil){
        p= [NSPredicate predicateWithFormat:@"a_channel_id = %@ and a_article_id <>%@", channel.channel_id,exceptArticle.article_id];
    }else{
        p=  [NSPredicate predicateWithFormat:@"a_channel_id = %@", channel.channel_id];
    }
    NSSortDescriptor *sortPublishTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubish_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPublishTimeDescriptor, nil];
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
    Article *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
        e_article.is_read=YES;
    }
}
-(void)markArticleFavorWithArticleID:(NSString *)articleID is_collected:(BOOL)is_collected{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"article_id = %@", articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    Article *e_article;
    if([result count]==1){
        e_article=[result objectAtIndex:0];
        e_article.is_collected=is_collected;
    }
    
}
-(BOOL)doesArticleExistWithArtilceID:(NSString *)articleID{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"article_id = %@",articleID];
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
    NSPredicate * p = [NSPredicate predicateWithFormat:@"article_id = %@",articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    if([result count]>0){
        return result[0];
    }else{
        return nil;
    }
}
-(void)updateArticleTimeWithArticleID:(NSString *)articleID newTime:(NSString *)newTime{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"article_id = %@",articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    for(Article *article in result){
        article.publish_date=newTime;
    }
}
-(void)deleteArticleWithArticleID:(NSString *)articleID{
    NSEntityDescription * e_article_desc = [NSEntityDescription entityForName:E_ARTICLE inManagedObjectContext:_context];
    NSPredicate * p = [NSPredicate predicateWithFormat:@"article_id = %@",articleID];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:e_article_desc];
    [frq setPredicate:p];
    NSArray *result =[_context executeFetchRequest:frq error:nil];
    for(Article *article in result){
        [_context deleteObject:article];
    }
}
@end
