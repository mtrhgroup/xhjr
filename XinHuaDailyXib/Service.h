//
//  Service.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import <Foundation/Foundation.h>
#import "Channel.h"
#import "Article.h"
#import "AppInfo.h"
#import "UserDefaults.h"
@interface Service : NSObject
@property(nonatomic,strong)UserDefaults *user_defaults;
//网络
-(void)registerDevice:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)registerSNWithSN:(NSString *)SN successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchHomeArticlesFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchChannelsFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchArticlesFromNETWithChannel:(Channel *)channel successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchMoreArticlesFromNETWithChannel:(Channel *)channel last_article:(Article *)last_article successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchAppInfo:(void(^)(AppInfo *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)executeServerCommands:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)reportActionsToServer:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchOneArticleWithArticleID:(NSString *)articleID successHandler:(void(^)(Article *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchArticleContentWithArticle:(Article *)article successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
//本地
-(NSArray *)fetchFavorArticlesFromDB;
-(NSArray *)fetchTrunkChannelsFromDB;
-(NSArray *)fetchLeafChannelsFromDBWithTrunkChannel:(Channel *)channel;
-(ArticlesForCVC *)fetchArticlesFromDBWithChannel:(Channel *)channel topN:(int)topN;
-(void)markArticleCollectedWithArticle:(Article *)article is_collected:(BOOL)is_collected;
-(void)markArticleReadWithArticle:(Article *)article;
-(Article *)fetchADArticleFromDB;
-(NSArray *)fetchPushArticlesFromDB;
-(ChannelsForHVC *)fetchHomeArticlesFromDB;
-(NSArray *)fetchArticlesThatIncludeCoverImage;

-(BOOL)authorize;
-(BOOL)hasAuthorized;

@end
