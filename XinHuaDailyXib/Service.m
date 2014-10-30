//
//  Service.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import "Service.h"
#import "Communicator.h"
#import "Parser.h"
#import "DBManager.h"
#import "DBOperator.h"
#import "FSManager.h"
#import "URLDefine.h"
#import "DeviceInfo.h"
#import "UserDefaults.h"
#import "Command.h"
#import "UserActions.h"
#import "NetworkLostError.h"
#import "DefaultError.h"
#import "ParserFailedError.h"
@implementation Service{
    Communicator *_communicator;
    Parser *_parser;
    DBManager *_db_manager;
    FSManager *_fs_manager;
    UserActions *_userActions;
}
@synthesize fs_manager=_fs_manager;
-(id)init{
    if(self=[super init]){
        _communicator=[[Communicator alloc]init];
        _db_manager=[[DBManager alloc] init];
        _fs_manager=[[FSManager alloc] init];
        _parser=[[Parser alloc] init];
        _userActions=[[UserActions alloc]initWithCommunicator:_communicator];
    }
    return self;
}
-(void)registerDevice:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kBindleDeviceURL,[DeviceInfo udid],[DeviceInfo phoneModel],[DeviceInfo osVersion]];
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        if([responseStr rangeOfString:@"OLD"].location!=NSNotFound||[responseStr rangeOfString:@"NEW"].location!=NSNotFound){
//            if(responseStr.length>3){
//                NSString *snStr=[responseStr substringFromIndex:4];
//                AppDelegate.user_defaults.sn=snStr;
//            }
            if(successBlock){
                successBlock(YES);
            }
        }else{
            if(errorBlock){
                errorBlock([DefaultError aErrorWithMessage:[responseStr substringFromIndex:3]]);
            }
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)registerPhoneNumberWithPhoneNumber:(NSString *)phone_number verifyCode:(NSString *)verify_code successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kBindleSNURL,phone_number,[DeviceInfo udid],verify_code,[DeviceInfo phoneModel],[DeviceInfo osVersion]];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        if([responseStr rangeOfString:@"OK"].location!=NSNotFound){
            AppDelegate.user_defaults.sn=phone_number;
            if(successBlock){
                successBlock(YES);
            }
        }else{
            if(errorBlock){
                errorBlock([DefaultError aErrorWithMessage:[responseStr substringFromIndex:3]]);
            }
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}

-(ChannelsForHVC *)fetchHomeArticlesFromDB{
    ChannelsForHVC *channels_for_hvc=[[ChannelsForHVC alloc] init];
    DBOperator *db_operator=[_db_manager aOperator];
    NSArray *home_channels=[db_operator fetchHomeChannels];
    for(Channel *channel in home_channels){
       channel.articles=[db_operator fetchArticlesWithChannel:channel exceptArticle:nil topN:channel.home_number.intValue];
    }
    Channel *pic_channel=[db_operator fetchPicChannel];
    int topN=(int)fabs(pic_channel.home_number.intValue);
    pic_channel.articles=[db_operator fetchArticlesWithChannel:pic_channel exceptArticle:nil topN:topN];
    channels_for_hvc.header_channel=pic_channel;
    channels_for_hvc.other_channels=home_channels;
    return channels_for_hvc;
}
-(void)fetchHomeArticlesFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    DBOperator *db_operator=[_db_manager aOperator];
    Channel *pic_channel=[db_operator fetchPicChannel];
    NSArray *other_channels=[db_operator fetchHomeChannels];
    NSMutableArray *home_channels=[[NSMutableArray alloc]init];
    if(pic_channel!=nil){
        [home_channels addObject:pic_channel];
    }
    [home_channels addObjectsFromArray:other_channels];
    for(Channel *channel in home_channels){
        int topN=(int)fabs([channel.home_number intValue]);
        NSString *url=[NSString stringWithFormat:kLatestArticlesURL,[DeviceInfo udid],topN,channel.channel_id];
        [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSArray *articles=[_parser parseArticles:responseStr];
                for(Article *article in articles){
                    if(![db_operator doesArticleExistWithArtilceID:article.article_id]){
                        [db_operator addArticle:article];
                        [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationArticleReceived object: article.channel_id ];
                    }
                    if(!article.is_cached){
                        [self fetchArticleContentWithArticle:article successHandler:^(BOOL ok){
                            // <#code#>
                            //TODO ssss
                        } errorHandler:^(NSError *error) {
                            if(errorBlock){
                                errorBlock(error);
                            }
                        }];
                    }
                }
                [db_operator save];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(successBlock){
                        successBlock(articles);
                    }
                });
            });
        } errorHandler:^(NSError *error) {
            if(errorBlock){
                errorBlock(error);
            }
        }];
    }
}

-(void)fetchAppInfo:(void (^)(AppInfo *))successBlock errorHandler:(void (^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kAppInfoURL,[DeviceInfo udid]];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        AppInfo *app_info=[_parser parseAppInfo:responseStr];
        AppDelegate.user_defaults.appInfo=app_info;
        [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationAppVersionReceived object: nil];
        if(app_info.gid!=nil||![app_info.gid isEqualToString:@""]){
            [self fetchOneArticleWithArticleID:app_info.gid successHandler:^(Article *article) {
                [self fetchArticleContentWithArticle:article successHandler:^(BOOL is_ok) {
                    app_info.advPagePath=article.page_path;
                    app_info.advPath=article.zip_path;
                    app_info.startImgUrl=article.thumbnail_url;
                    AppDelegate.user_defaults.appInfo=app_info;
                    if(successBlock){
                        successBlock(app_info);
                    }
                } errorHandler:^(NSError *error) {
                    if(errorBlock){
                        errorBlock(error);
                    }
                }];
            } errorHandler:^(NSError *error) {
                if(errorBlock){
                    errorBlock(error);
                }
            }];
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchChannelsFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kChannelsURL,[DeviceInfo udid]];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *channels=[_parser parseChannels:responseStr];
            DBOperator *db_operator=[_db_manager aOperator];
            if([channels count]>0){
                [db_operator removeAllChannels];
            }
            for(Channel *channel in channels){
                [db_operator addChannel:channel];
            }
            [db_operator save];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationChannelsUpdate object: nil];
                    successBlock(channels);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchArticlesFromNETWithChannel:(Channel *)channel successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kLatestArticlesURL,[DeviceInfo udid],10,channel.channel_id];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *articles=[_parser parseArticles:responseStr];
            DBOperator *db_operator=[_db_manager aOperator];
            for(Article *article in articles){
                [db_operator addArticle:article];
            }
            [db_operator save];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    successBlock(articles);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchMoreArticlesFromNETWithChannel:(Channel *)channel last_article:(Article *)last_article successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    
}
-(void)fetchArticleContentWithArticle:(Article *)article successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    [_communicator fetchFileAtURL:article.zip_url toPath:article.zip_path successHandler:^(BOOL is_ok) {
        if(is_ok){
            if(successBlock){
                successBlock(YES);
            }
        }else{
            NSError *error;
            if(errorBlock){
                errorBlock(error);
            }
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}

-(void)executeServerCommands:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kCommandsURL,[DeviceInfo udid]];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *commands=[_parser parseCommands:responseStr];
            DBOperator *db_operator=[_db_manager aOperator];
            BOOL modified=NO;
            for(Command *command in commands){
                if([self executeCommand:command db_operator:db_operator]){
                    modified=YES;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    successBlock(modified);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(BOOL)executeCommand:(Command *)command db_operator:(DBOperator *)db_operator{
        if([db_operator doesArticleExistWithArtilceID:command.f_id]){
            if([command.f_state isEqualToString:@"2"]){
                [db_operator deleteArticleWithArticleID:command.f_id];
               // [[FileSystem system] removeArticle:[db_operator fetchArticleWithArticleID:command.f_id]];
            }else if([command.f_state isEqualToString:@"1"]){
                [db_operator updateArticleTimeWithArticleID:command.f_id newTime:command.f_inserttime];
            }
            [db_operator save];
            return YES;
        }else{
            return NO;
        }
}

-(void)reportActionsToServer:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    [_userActions reportActionsToServer:successBlock errorHandler:errorBlock];
}

-(void)fetchOneArticleWithArticleID:(NSString *)articleID successHandler:(void(^)(Article *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kOneArticleURL,articleID,[DeviceInfo udid]];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            Article *article=[_parser parseOneArticle:responseStr];
            DBOperator *db_operator=[_db_manager aOperator];
            [db_operator addArticle:article];
            [db_operator save];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    successBlock(article);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}

//本地
-(NSArray *)fetchFavorArticlesFromDB{
    NSArray *articles=[[_db_manager aOperator] fetchFavorArticles];
    return articles;
}
-(NSArray *)fetchTrunkChannelsFromDB{
    NSArray * channels=[[_db_manager aOperator] fetchTrunkChannels];
    NSMutableArray *res=[[NSMutableArray alloc]init];
    for (Channel* ch in channels) {
        [res addObject:ch];
    }
    return res;
}
-(NSArray *)fetchHomeChannelsFromDB{
    return [[_db_manager aOperator] fetchHomeChannels];
}
-(NSArray *)fetchLeafChannelsFromDBWithTrunkChannel:(Channel *)channel{
    DBOperator *db_operator=[_db_manager aOperator];
    return [db_operator fetchLeafChannelsWithTrunkChannel:channel];
}
-(ArticlesForCVC *)fetchArticlesFromDBWithChannel:(Channel *)channel topN:(int)topN{
    DBOperator *db_operator=[_db_manager aOperator];
    Article *header_article=[db_operator fetchHeaderArticleWithChannel:channel];
    NSArray *other_articles=[db_operator fetchArticlesWithChannel:channel exceptArticle:header_article topN:topN];
    ArticlesForCVC *articles_for_cvc=[[ArticlesForCVC alloc]init];
    articles_for_cvc.header_article=header_article;
    articles_for_cvc.other_articles=other_articles;
    return articles_for_cvc;
}
-(BOOL)hasNewerArticlesThanArticle:(Article *)article in_channel:(Channel *)in_channel{
    DBOperator *db_operator=[_db_manager aOperator];
    NSArray *articles=[db_operator fetchArticlesWithChannel:in_channel exceptArticle:nil topN:1];
    if([articles count]>0){
    Article *latest_article=[articles objectAtIndex:0];
    if([latest_article.article_id isEqualToString:article.article_id]){
        return YES;
    }else{
        return NO;
    }
    }else{
        return NO;
    }
}
-(void)markArticleCollectedWithArticle:(Article *)article is_collected:(BOOL)is_collected{
    DBOperator *db_operator=[_db_manager aOperator];
    [db_operator markArticleFavorWithArticleID:article.article_id is_collected:is_collected];
    [db_operator save];
}
-(void)markArticleReadWithArticle:(Article *)article{
    [_userActions enqueueAReadAction:article.article_id];
    DBOperator *db_operator=[_db_manager aOperator];
    [db_operator markArticleReadWithArticleID:article.article_id];
    [db_operator save];
}
-(void)markArticleLikeWithArticle:(Article *)article{
    DBOperator *db_operator=[_db_manager aOperator];
    [db_operator markArticleLikeWithArticleID:article.article_id];
    [db_operator save];
}
-(Article *)fetchADArticleFromDB{
    DBOperator *db_operator=[_db_manager aOperator];
    Channel* channel=[db_operator fetchADChannel];
    NSArray *articles=[db_operator fetchArticlesWithChannel:channel exceptArticle:nil topN:1];
    if([articles count]>0){
        return [articles objectAtIndex:0];
    }else{
        return nil;
    }
}
-(NSArray *)fetchPushArticlesFromDB{
    NSArray *articles=[[_db_manager aOperator] fetchArticlesThatIsPushed];
    return articles;
}
-(NSArray *)fetchArticlesThatIncludeCoverImage{
    NSArray *articles=[[_db_manager aOperator] fetchArticlesThatIncludeCoverImage];
    return articles;
}
-(BOOL)authorize{
    return NO;
}
-(BOOL)hasAuthorized{
    return NO;
}
-(void)likeArticleWithArticle:(Article *)article successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kLikeURL,[DeviceInfo udid],article.article_id];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        if(successBlock){
            successBlock(responseStr);
        }
        
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)shareArticleWithArticle:(Article *)article{
    
}
-(void)feedbackArticleWithContent:(NSString *)content article:(Article *)article successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kArticleFeedBack,[DeviceInfo udid],AppDelegate.user_defaults.sn,article.article_id,content];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        if([responseStr rangeOfString:@"OK"].location!=NSNotFound){
            if(successBlock){
                successBlock(YES);
            }
        }else{
            if(errorBlock){
                errorBlock([DefaultError aErrorWithMessage:[responseStr substringFromIndex:3]]);
            }
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)feedbackAppWithContent:(NSString *)content email:(NSString *)email successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kAppFeedBack,[DeviceInfo udid],AppDelegate.user_defaults.sn,email,content];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        if([responseStr rangeOfString:@"OK"].location!=NSNotFound){
            if(successBlock){
                successBlock(YES);
            }
        }else{
            if(errorBlock){
                errorBlock([DefaultError aErrorWithMessage:[responseStr substringFromIndex:3]]);
            }
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)requestVerifyCodeWithPhoneNumber:(NSString *)phone_number successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kMMSVeriyCodeURL,[DeviceInfo udid],phone_number];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        if([responseStr rangeOfString:@"OK"].location!=NSNotFound){
            if(successBlock){
                successBlock(YES);
            }
        }else{
            if(errorBlock){
                errorBlock([DefaultError aErrorWithMessage:[responseStr substringFromIndex:3]]);
            }
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock([NetworkLostError aError]);
        }
    }];
}
@end
