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
-(Channel *)fetchMRCJChannel;
-(Channel *)fetchPicChannel;
-(NSArray *)fetchHomeChannels;
-(NSArray *)fetchAllChannels;
-(NSArray *)fetchArticlesThatIsPushed;
-(NSArray *)fetchArticlesThatIncludeCoverImage;
-(void)removeAllChannels;
-(void)addArticle:(Article *)article;
-(Article *)fetchHeaderArticleWithChannel:(Channel *)channel;
-(NSArray *)fetchArticlesWithChannel:(Channel *)channel exceptArticle:(Article *)exceptArticle topN:(int)topN;
-(NSArray *)fetchDailyArticlesWithChannel:(Channel *)channel date:(NSString *)date;
-(NSArray *)fetchArticlesWithTag:(NSString *)tag;
-(NSString *)queryNextAvailableDateWithChannel:(Channel *)channel date:(NSString *)date;
-(NSString *)queryPreviousAvailableDateWithChannel:(Channel *)channel date:(NSString *)date;
-(NSString *)queryLatestAvailableDateWithChannel:(Channel *)channel;
-(NSArray *)fetchFavorArticles;
-(NSDate *)markChannelAccessTimeStampWithChannel:(Channel *)channel;
-(NSDate *)markChannelReceiveNewArticlesTimeStampWithChannelID:(NSString *)channel_id;
-(void)markArticleReadWithArticleID:(NSString *)articleID;
-(void)markArticleLikeWithArticleID:(NSString *)articleID likeNumber:(NSNumber *)likeNumber;
-(void)markArticleFavorWithArticleID:(NSString *)articleID is_collected:(BOOL)is_collected;
-(BOOL)doesArticleExistWithArtilceID:(NSString *)articleID;
-(Article *)fetchArticleWithArticleID:(NSString *)articleID;
-(void)updateArticleTimeWithArticleID:(NSString *)articleID newTime:(NSString *)newTime;
-(void)deleteArticleWithArticleID:(NSString *)articleID;
@end
