//
//  DBOperator.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/9.
//
//

#import <Foundation/Foundation.h>
#import "Channel.h"
#import "Article.h"
@interface DBOperator : NSObject
-(id)initWithContext:(NSManagedObjectContext *)context;
-(BOOL)save;
-(void)addChannel:(Channel *)channel;
-(NSArray *)fetchTrunkChannels;
-(NSArray *)fetchLeafChannelsWithTrunkChannel:(Channel *)trunk_channel;
-(Channel *)fetchADChannel;
-(NSArray *)fetchNotificationArticles;
-(void)removeAllChannels;
-(void)addArticle:(Article *)article;
-(Article *)fetchHeaderArticleWithChannel:(Channel *)channel;
-(NSArray *)fetchArticlesWithChannel:(Channel *)channel exceptArticle:(Article *)exceptArticle topN:(int)topN;
-(NSArray *)fetchFavorArticles;
-(void)markArticleReadWithArticleID:(NSString *)articleID;
-(void)markArticleFavorWithArticleID:(NSString *)articleID favor:(BOOL)favor;
-(void)deleteArticleWithArticleIDs:(NSString *)articleID;
@end
