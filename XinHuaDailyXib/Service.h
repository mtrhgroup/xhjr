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
@interface Service : NSObject
//网络
-(void)fetchChannelsFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchArticlesFromNETWithChannel:(Channel *)channel successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)registerDevice:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)registerSNWithSN:(NSString *)SN successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchAppInfo:(void(^)(AppInfo *))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)executeModifyActions:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchArticlesForHomeVC:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)reportActionsToServer:(NSString *)postJSON succcessHander:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock;
-(void)fetchOneArticleWithArticleID:(NSString *)articleID successHandler:(void(^)(Article *))successBlock errorHandler:(void(^)(NSError *))errorBlock;

//本地
-(NSArray *)fetchFavorArticlesFromDB;
-(NSArray *)fetchTrunkChannelsFromDB;
-(NSArray *)fetchLeafChannelsFromDBWithTrunkChannel:(Channel *)channel;
-(NSArray *)fetchArticlesFromDBWithChannel:(Channel *)channel topN:(int)topN;
-(void)markArticleFavorInDB:(Article *)article favor:(BOOL)favor;
-(void)markArticleReadWithArticleInDB:(Article *)article;
-(Article *)fetchADArticleFromDB;
-(NSArray *)fetchPushArticlesFromDB;

//配置
-(NSString *)getFontSize;
-(void)saveFontSize:(NSString *)fontSize;
@end
