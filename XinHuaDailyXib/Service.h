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
#import "FSManager.h"
@interface Service : NSObject
@property(nonatomic,strong)FSManager *fs_manager;
//网络
//-(void)registerDevice:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)registerPhoneNumberWithPhoneNumber:(NSString *)phone_number verifyCode:(NSString *)verify_code successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchChannelsFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchHomeArticlesFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchArticlesFromNETWithChannel:(Channel *)channel time:(NSString *)time successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchDailyArticlesFromNETWithChannel:(Channel *)channel time:(NSString *)time successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchAppInfo:(void(^)(AppInfo *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)executeServerCommands:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)reportActionsToServer:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchOneArticleWithArticleID:(NSString *)articleID successHandler:(void(^)(Article *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchArticleContentWithArticle:(Article *)article successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)likeArticleWithArticle:(Article *)article successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)shareArticleWithArticle:(Article *)article;
-(void)feedbackArticleWithContent:(NSString *)content article:(Article *)article successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)feedbackAppWithContent:(NSString *)content email:(NSString *)email successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)requestVerifyCodeWithPhoneNumber:(NSString *)phone_number successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;

//本地
-(NSArray *)fetchFavorArticlesFromDB;
-(NSArray *)fetchTrunkChannelsFromDB;
-(NSArray *)fetchLeafChannelsFromDBWithTrunkChannel:(Channel *)channel;
-(ArticlesForCVC *)fetchArticlesFromDBWithChannel:(Channel *)channel topN:(int)topN;
-(NSArray *)fetchDailyArticlesFromDBWithChannel:(Channel *)channel date:(NSString *)date;
-(NSDate *)markAccessTimeStampWithChannel:(Channel *)channel;
-(void)markArticleCollectedWithArticle:(Article *)article is_collected:(BOOL)is_collected;
-(void)markArticleReadWithArticle:(Article *)article;
-(void)markArticleLikeWithArticle:(Article *)article;
-(Article *)fetchADArticleFromDB;
-(NSArray *)fetchPushArticlesFromDB;
-(ChannelsForHVC *)fetchHomeArticlesFromDB;
-(NSArray *)fetchArticlesThatIncludeCoverImage;

-(Channel *)fetchMRCJChannelFromDB;
-(void)becomeAcitveHandler;
-(BOOL)hasAuthorized;
@end
