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
#import "XHDeviceInfo.h"
#import "UserDefaults.h"
#import "Command.h"
#import "UserActions.h"
#import "NetworkLostError.h"
#import "DefaultError.h"
#import "ParserFailedError.h"
#import "BindleLostError.h"
#import "Util.h"
@implementation Service{
    Communicator *_communicator;
    Parser *_parser;
    DBManager *_db_manager;
    FSManager *_fs_manager;
    UserActions *_userActions;
    NSMutableDictionary *_new_version;
}
@synthesize fs_manager=_fs_manager;
-(id)init{
    if(self=[super init]){
        _communicator=[[Communicator alloc]init];
        _db_manager=[[DBManager alloc] init];
        _fs_manager=[[FSManager alloc] init];
        _parser=[[Parser alloc] init];
        _userActions=[[UserActions alloc]initWithCommunicator:_communicator];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(becomeAcitveHandler)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}
#ifdef DFN
-(void)fetchFirstRunData:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    [self fetchChannelsFromNET:^(NSArray *channels) {
        AppDelegate.channel=[self fetchMRCJChannelFromDB];
        [self fetchLatestArticlesFromNETWithChannel:AppDelegate.channel successHandler:^(NSArray *articles) {
            if([articles count]>0){
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
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}

-(void)becomeAcitveHandler{
    if(![self hasAuthorized])return;
    [self reportActionsToServer:^(BOOL ok) {
        //<#code#>
    } errorHandler:^(NSError *error) {
        // <#code#>
    }];
    [self fetchChannelsFromNET:^(NSArray *channels) {
        AppDelegate.channel=[self fetchMRCJChannelFromDB];
        [self fetchLatestArticlesFromNETWithChannel:AppDelegate.channel successHandler:^(NSArray *articles) {
          //  <#code#>
        } errorHandler:^(NSError *error) {
          //  <#code#>
        }];
    } errorHandler:^(NSError *error) {
        //
    }];
}
#endif
#ifdef LNFB
-(void)fetchFirstRunData:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    [self fetchChannelsFromNET:^(NSArray *channels) {
        [self fetchHomeArticlesFromNET:^(NSArray *articles) {
            //
        } errorHandler:^(NSError *error) {
            //
        }];
    } errorHandler:^(NSError *error) {
        //
    }];
}
-(void)becomeAcitveHandler{
    [self reportActionsToServer:^(BOOL ok) {
        //<#code#>
    } errorHandler:^(NSError *error) {
        // <#code#>
    }];
    [self fetchChannelsFromNET:^(NSArray *channels) {
        [self fetchHomeArticlesFromNET:^(NSArray *articles) {
            //
        } errorHandler:^(NSError *error) {
            //
        }];
    } errorHandler:^(NSError *error) {
        //
    }];
}
#endif
#ifdef Ocean
-(void)fetchFirstRunData:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    [self fetchChannelsFromNET:^(NSArray *channels) {
        [self fetchKeywordsWithSuccessHandler:^(NSArray * keywords){
            if(successBlock){
                successBlock(YES);
            }
        } errorHandler:^(NSError *error){
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
-(void)becomeAcitveHandler{
    [self becomeAcitveHandlerWithSuccessHandler:^(NSArray *articles) {
        //
    } errorHandler:^(NSError *error) {
        //
    }];
}
-(void)becomeAcitveHandlerWithSuccessHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    ArticlesForHVC *article_for_hvc=[[ArticlesForHVC alloc] init];
    [self reportActionsToServer:^(BOOL ok) {
        //<#code#>
    } errorHandler:^(NSError *error) {
        // <#code#>
    }];
    [self fetchChannelsFromNET:^(NSArray *channels) {
        [self fetchKeywordsWithSuccessHandler:^(NSArray * keywords){
            [self fetchOceanHomeArticlesFromNETWithAritclesForHVC:article_for_hvc successHandler:^(NSArray *articles){
                if(successBlock){
                    successBlock(articles);
                }
            } errorHandler:^(NSError *error){
                if(errorBlock){
                    errorBlock(error);
                }
            }];
            
        } errorHandler:^(NSError *error){
            
        }];

    } errorHandler:^(NSError *error) {
        //
    }];

}
#endif

#ifdef Money
-(void)fetchFirstRunData:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    [self fetchChannelsFromNET:^(NSArray *channels) {
        [self fetchKeywordsWithSuccessHandler:^(NSArray * keywords){
            if(successBlock){
                successBlock(YES);
            }
        } errorHandler:^(NSError *error){
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
-(void)becomeAcitveHandler{
    [self becomeAcitveHandlerWithSuccessHandler:^(NSArray *articles) {
        //
    } errorHandler:^(NSError *error) {
        //
    }];
}
-(void)becomeAcitveHandlerWithSuccessHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    ArticlesForHVC *article_for_hvc=[[ArticlesForHVC alloc] init];
    [self reportActionsToServer:^(BOOL ok) {
        //<#code#>
    } errorHandler:^(NSError *error) {
        // <#code#>
    }];
    [self fetchChannelsFromNET:^(NSArray *channels) {
        [self fetchKeywordsWithSuccessHandler:^(NSArray * keywords){
            [self fetchOceanHomeArticlesFromNETWithAritclesForHVC:article_for_hvc successHandler:^(NSArray *articles){
                if(successBlock){
                    successBlock(articles);
                }
            } errorHandler:^(NSError *error){
                if(errorBlock){
                    errorBlock(error);
                }
            }];
            
        } errorHandler:^(NSError *error){
            
        }];
        
    } errorHandler:^(NSError *error) {
        //
    }];
    
}
#endif
-(void)registerDevice:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kBindleDeviceURL,[XHDeviceInfo udid],[XHDeviceInfo phoneModel],[XHDeviceInfo osVersion],AppID];
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        if([responseStr rangeOfString:@"OLD"].location!=NSNotFound){
            NSArray *comp=[responseStr componentsSeparatedByString:@":"];
            if([comp count]==2){
                NSLog(@"%@",AppDelegate.user_defaults.sn);
                if([[comp objectAtIndex:1] isEqualToString:AppDelegate.user_defaults.sn]){
                    if(successBlock){
                        successBlock(YES);
                    }
                }else{
                    AppDelegate.user_defaults.sn=@"";
                    if(errorBlock){
                        errorBlock([BindleLostError aError]);
                    }
                }
            }else{
                if(errorBlock){
                    errorBlock([BindleLostError aError]);
                }
            }
            
        }else if([responseStr rangeOfString:@"NEW"].location!=NSNotFound){
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
    NSString *url=[NSString stringWithFormat:kBindleSNURL,phone_number,[XHDeviceInfo udid],verify_code,[XHDeviceInfo phoneModel],[XHDeviceInfo osVersion],AppID];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        if([responseStr rangeOfString:@"OK"].location!=NSNotFound){
            AppDelegate.user_defaults.sn=[NSString stringWithFormat:@"%@_%@",AppID,phone_number];
            [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationBindSNSuccess object:nil];
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
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    NSArray *home_channels=[db_operator fetchHomeChannels];
    for(Channel *channel in home_channels){
       channel.articles=[db_operator fetchArticlesWithChannel:channel exceptArticle:nil topN:channel.home_number];
    }
    Channel *pic_channel=[db_operator fetchPicChannel];
    int topN=(int)fabs(pic_channel.home_number);
    pic_channel.articles=[db_operator fetchArticlesWithChannel:pic_channel exceptArticle:nil topN:topN];
    channels_for_hvc.header_channel=pic_channel;
    channels_for_hvc.other_channels=home_channels;
    return channels_for_hvc;
}
-(void)fetchOceanHomeArticlesFromNETWithAritclesForHVC:(ArticlesForHVC *)aritclesForHVC successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    [self registerDevice:^(BOOL isOK) {
        DBOperator *db_operator=[_db_manager theForegroundOperator];
        NSArray *channels=[db_operator fetchAllChannels];
        for(Channel *channel in channels){
            if(!channel.is_leaf)continue;
            if(channel.need_be_authorized&&!AppDelegate.user_defaults.is_authorized)continue;
            int topN=10;//默认下载5条
            if([channel.parent_id isEqualToString:@"-1"])topN=1;//广告下载1条
            NSString *time=[aritclesForHVC lastPublicDateInChannelWithChannelID:channel.channel_id];
            if(time==nil)return;
            
            NSString *url=[NSString stringWithFormat:kLatestArticlesURL,[XHDeviceInfo udid],topN,channel.channel_id,time,AppID];
            [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    DBOperator *db_operator_background=[_db_manager aBackgroundOperator];
                    NSArray *articles=[_parser parseArticles:responseStr];
                    if([articles count]==1){
                        
                    }else{
                        for(Article *article in articles){
                            if(![db_operator_background doesArticleExistWithArtilceID:article.article_id]){
                                [db_operator_background addArticle:article];
                                channel.receive_new_articles_timestamp=[db_operator_background markChannelReceiveNewArticlesTimeStampWithChannelID:channel.channel_id];
                                NSDictionary *dict = [NSDictionary dictionaryWithObject:channel.receive_new_articles_timestamp forKey:@"timestamp"];
                                if(channel.parent_id.intValue>0){
                                    [db_operator_background markChannelReceiveNewArticlesTimeStampWithChannelID:channel.parent_id];
                                    [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationNewArticlesReceived object: channel.parent_id userInfo:dict];
                                }else{
                                    [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationNewArticlesReceived object: channel.channel_id userInfo:dict];
                                }
                            }
                            if(!article.is_cached&&channel.is_auto_cache){
                                [self fetchArticleContentWithArticle:article successHandler:^(BOOL ok){
                                    
                                } errorHandler:^(NSError *error) {
                                    
                                }];
                            }
                        }
                        [db_operator_background save];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self executeServerCommandsWithChannelID:channel.channel_id successHandler:^(BOOL isOK) {
                                if(successBlock){
                                    successBlock(articles);
                                }
                            } errorHandler:^(NSError *error) {
                                if(successBlock){
                                    successBlock(articles);
                                }
                            }];
                            
                        });
                    }
                });
            } errorHandler:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(errorBlock){
                        errorBlock(error);
                    }
                });
            }];
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(ArticlesForHVC *)fetchOceanHomeArticlesFromDBWithTopN:(int)topN{
    ArticlesForHVC *articles_for_hvc=[[ArticlesForHVC alloc] init];
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    NSArray *topic_channels=[db_operator fetchTopicChannels];
    if(topic_channels.count>0){
        Channel *topic_channel=[topic_channels objectAtIndex:0];
        NSMutableArray *other_articles;
        if(topic_channel.sort_number==0){
            Article *header_article=[[Article alloc] init];
            header_article.is_topic_channel=YES;
            header_article.thumbnail_url=topic_channel.icon_url;
            header_article.page_url=topic_channel.description;
            header_article.article_title=topic_channel.channel_name;
            articles_for_hvc.header_article=header_article;
            other_articles=[[NSMutableArray alloc] initWithArray:[db_operator fetchOtherArticlesWithExceptArticle:nil topN:topN]];
        }else{
            Article *header_article=[db_operator fetchHeaderArticle];
            articles_for_hvc.header_article=header_article;
            other_articles=[[NSMutableArray alloc] initWithArray:[db_operator fetchOtherArticlesWithExceptArticle:header_article topN:topN]];
        }
        for(Channel *channel in topic_channels){
            if(channel.sort_number!=0){
                Article *article=[[Article alloc] init];
                article.is_topic_channel=YES;
                article.thumbnail_url=channel.icon_url;
                article.page_url=channel.description;
                article.article_title=topic_channel.channel_name;
                if(channel.sort_number-1<[other_articles count]){
                    [other_articles insertObject:article atIndex:channel.sort_number-1];
                }
            }
        }
        articles_for_hvc.other_articles=other_articles;
        
    }else{
        Article *header_article=[db_operator fetchHeaderArticle];
        articles_for_hvc.header_article=header_article;
        NSArray *other_articles=[db_operator fetchOtherArticlesWithExceptArticle:header_article topN:topN];
        articles_for_hvc.other_articles=other_articles;
    }
    
    return articles_for_hvc;
}
-(void)fetchHomeArticlesFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    NSArray *channels=[db_operator fetchAllChannels];
    for(Channel *channel in channels){
        if(!channel.is_leaf)continue;
        if(channel.need_be_authorized&&!AppDelegate.user_defaults.is_authorized)continue;
        int topN=5;//默认下载5条
        topN=(int)fabs(channel.home_number);//首页显示几条，下载几条
        if([channel.parent_id isEqualToString:@"-1"])topN=1;//广告下载1条
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *time=[formatter stringFromDate:[NSDate distantFuture]];
        NSString *url=[NSString stringWithFormat:kLatestArticlesURL,[XHDeviceInfo udid],topN,channel.channel_id,time,AppID];
        NSLog(@"####%@ %@",channel.channel_name,url);
        [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                DBOperator *db_operator_background=[_db_manager aBackgroundOperator];
                NSArray *articles=[_parser parseArticles:responseStr];
                for(Article *article in articles){
                    if(![db_operator_background doesArticleExistWithArtilceID:article.article_id]){
                        [db_operator_background addArticle:article];
                            channel.receive_new_articles_timestamp=[db_operator_background markChannelReceiveNewArticlesTimeStampWithChannelID:channel.channel_id];
                            NSDictionary *dict = [NSDictionary dictionaryWithObject:channel.receive_new_articles_timestamp forKey:@"timestamp"];
                            if(channel.parent_id.intValue>0){
                                [db_operator_background markChannelReceiveNewArticlesTimeStampWithChannelID:channel.parent_id];
                                [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationNewArticlesReceived object: channel.parent_id userInfo:dict];
                            }else{
                                [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationNewArticlesReceived object: channel.channel_id userInfo:dict];
                            }
                    }
                    if(!article.is_cached&&channel.is_auto_cache){
                        [self fetchArticleContentWithArticle:article successHandler:^(BOOL ok){
                            // <#code#>
                            //TODO ssss
                        } errorHandler:^(NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if(errorBlock){
                                    errorBlock(error);
                                }
                            });
                        }];
                    }
                }
                [db_operator_background save];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self executeServerCommandsWithChannelID:channel.channel_id successHandler:^(BOOL isOK) {
                        if(successBlock){
                            successBlock(articles);
                        }
                    } errorHandler:^(NSError *error) {
                        if(successBlock){
                            successBlock(articles);
                        }
                    }];
                    
                });
                
            });
        } errorHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(errorBlock){
                    errorBlock(error);
                }
            });
        }];
    }
}

-(void)fetchAppInfo:(void (^)(AppInfo *))successBlock errorHandler:(void (^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kAppInfoURL,[XHDeviceInfo udid],AppID];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        AppInfo *app_info=[_parser parseAppInfo:responseStr];
        AppDelegate.user_defaults.appInfo=app_info;
        [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationAppVersionReceived object: nil];
        if(app_info.gid!=nil||![app_info.gid isEqualToString:@""]){
            [self fetchOneArticleWithArticleID:app_info.gid successHandler:^(Article *article) {
                [self fetchArticleContentWithArticle:article successHandler:^(BOOL is_ok) {
                    app_info.advPagePath=article.page_path;
                    app_info.advPath=article.zip_path;
                    app_info.startImgUrl=article.cover_image_url;
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(errorBlock){
                        errorBlock(error);
                    }
                });
            }];
        }
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchChannelsFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kChannelsURL,[XHDeviceInfo udid],AppID];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *channels=[_parser parseChannels:responseStr];
            
            DBOperator *db_operator=[_db_manager aBackgroundOperator];
            NSArray *local_channels=[db_operator fetchAllChannels];
            NSMutableArray *toDeleteChannels=[NSMutableArray array];
            for(Channel *local_channel in local_channels){
                BOOL toDelete=YES;
                for(Channel *channel in channels){
                    if([channel.channel_id isEqualToString:local_channel.channel_id]){
                        toDelete=NO;
                    }
                }
                if(toDelete){
                    [toDeleteChannels addObject:local_channel];
                }
            }
            for(Channel *channel in toDeleteChannels){
                [db_operator removeChannel:channel];
            }
            for(Channel *channel in channels){
                [db_operator addChannel:channel];
            }
            [db_operator save];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationChannelsReceived object: nil];
                if(successBlock){
                    successBlock(channels);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(errorBlock){
                errorBlock(error);
            }
        });
    }];
}
-(void)fetchLatestArticlesFromNETWithChannel:(Channel *)channel successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    [self registerDevice:^(BOOL isOK) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *time=[formatter stringFromDate:[NSDate distantFuture]];
        [self fetchArticlesFromNETWithChannel:channel time:time successHandler:^(NSArray *articles) {
            [self executeServerCommandsWithChannelID:channel.channel_id successHandler:^(BOOL isOK) {
                if(successBlock){
                    successBlock(articles);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationLatestDailyReceived object: nil];
            } errorHandler:^(NSError *error) {
                if(successBlock){
                    successBlock(articles);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationLatestDailyReceived object: nil];
            }];
            
        } errorHandler:^(NSError *error){
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
-(void)fetchArticlesFromNETWithChannel:(Channel *)channel time:(NSString *)time successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kLatestArticlesURL,[XHDeviceInfo udid],20,channel.channel_id,time,AppID];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *articles=[_parser parseArticles:responseStr];
            DBOperator *db_operator=[_db_manager aBackgroundOperator];
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

-(void)fetchDailyArticlesFromNETWithChannel:(Channel *)channel date:(NSString *)date successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kDailyArticlesURL,[XHDeviceInfo udid],channel.channel_id,date,AppID];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *articles=[_parser parseArticles:responseStr];
            DBOperator *db_operator=[_db_manager aBackgroundOperator];
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

-(void)fetchCommentsNumberFromNETWith:(Article *)article successHandler:(void(^)(NSNumber *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kCommentsNumberURL,article.article_content_id];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSNumber *comments_number=[NSNumber numberWithInt:[responseStr intValue]];
            article.comments_number=comments_number;
            [self markArticleCommentsNumberWithArticle:article];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    successBlock(comments_number);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchCommentsFromNETWithArticle:(Article *)article time:(NSString *)time successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kCommentListURL,[XHDeviceInfo udid],AppDelegate.user_defaults.sn,AppID,20,article.article_content_id,time];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *comments=[_parser parseComments:responseStr];
            dispatch_async(dispatch_get_main_queue(), ^{     
                if(successBlock){
                    successBlock(comments);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchLatestCommentsFromNETWithArticle:(Article *)article successHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *time=[formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:1000]];
    [self fetchCommentsFromNETWithArticle:article time:time successHandler:^(NSArray *comments) {
        if(successBlock){
            successBlock(comments);
        }
    } errorHandler:^(NSError *error){
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)executeServerCommandsWithChannelID:(NSString *)channel_id successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kCommandsURL,[XHDeviceInfo udid],channel_id,@"10",AppID];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *commands=[_parser parseCommands:responseStr];
            DBOperator *db_operator=[_db_manager aBackgroundOperator];
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
    if(articleID==nil)return;
    NSString *url=[NSString stringWithFormat:kOneArticleURL,articleID,[XHDeviceInfo udid],AppID];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            Article *article=[_parser parseOneArticle:responseStr];
            DBOperator *db_operator=[_db_manager aBackgroundOperator];
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
    NSArray *articles=[[_db_manager theForegroundOperator] fetchFavorArticles];
    return articles;
}
-(NSArray *)fetchTrunkChannelsFromDB{
    NSArray * channels=[[_db_manager theForegroundOperator] fetchTrunkChannels];
    NSMutableArray *res=[[NSMutableArray alloc]init];
    for (Channel* ch in channels) {
        [res addObject:ch];
    }
    return res;
}

-(NSDate *)markAccessTimeStampWithChannel:(Channel *)channel{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    NSDate *timestamp=[db_operator markChannelAccessTimeStampWithChannel:channel];
    [db_operator save];
    return timestamp;
}

-(NSArray *)fetchLeafChannelsFromDBWithTrunkChannel:(Channel *)channel{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    return [db_operator fetchLeafChannelsWithTrunkChannel:channel];
}


-(ArticlesForCVC *)fetchArticlesFromDBWithChannel:(Channel *)channel topN:(int)topN{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    Article *header_article;
    if(channel.show_type==Grid){
        header_article=[db_operator fetchHeaderArticleWithChannel:channel];
    }else{
        header_article=nil;
    }
    NSArray *other_articles=[db_operator fetchArticlesWithChannel:channel exceptArticle:header_article topN:topN];
    ArticlesForCVC *articles_for_cvc=[[ArticlesForCVC alloc]init];
    articles_for_cvc.header_article=header_article;
    articles_for_cvc.other_articles=other_articles;
    return articles_for_cvc;
}
-(DailyArticles *)fetchLatestDailyArticlesFromDBWithChannel:(Channel *)channel{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    NSString *date=[db_operator queryLatestAvailableDateWithChannel:channel];
    if(date.length!=0){
        return [self fetchDailyArticlesFromDBWithChannel:channel date:date];
    }else{
        return nil;
    }
}
-(NSArray *)fetchLatestDailyTagsFromDBWithChannel:(Channel *)channel{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    NSString *date=[db_operator queryLatestAvailableDateWithChannel:channel];
    NSArray *articles=[db_operator fetchDailyArticlesWithChannel:channel date:date];
    NSMutableArray *tags=[[NSMutableArray alloc] init];
    for(Article *article in articles){
        NSArray *keywords= [article.key_words componentsSeparatedByString:NSLocalizedString(@",", nil)];
        for(NSString *tag in keywords){
            BOOL has=NO;
            if([tag isEqualToString:@""])continue;
            for(NSString *item in tags){
                if([item isEqualToString:tag]){
                    has=YES;
                }
            }
            if(!has){
                [tags addObject:tag];
            }
        }
    }
    return tags;
}
-(NSArray *)fetchArticlesFromDBWithTag:(NSString *)tag{
   DBOperator *db_operator=[_db_manager theForegroundOperator];
    return  [db_operator fetchArticlesWithTag:tag];
}
-(DailyArticles *)fetchDailyArticlesFromDBWithChannel:(Channel *)channel date:(NSString *)date{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    DailyArticles *das=[[DailyArticles alloc] init];
    das.date=date;
    das.articles=[db_operator fetchDailyArticlesWithChannel:channel date:date];
    das.previous_date=[db_operator queryPreviousAvailableDateWithChannel:channel date:date];
    das.next_date=[db_operator queryNextAvailableDateWithChannel:channel date:date];
    return das;
}

-(void)markArticleCollectedWithArticle:(Article *)article is_collected:(BOOL)is_collected{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    [db_operator markArticleFavorWithArticleID:article.article_id is_collected:is_collected];
    [db_operator save];
}
-(void)markArticleReadWithArticle:(Article *)article{
    [_userActions enqueueAReadAction:article.article_id];
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    [db_operator markArticleReadWithArticleID:article.article_id];
    [db_operator save];
}
-(void)markArticleLikeWithArticle:(Article *)article{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    [db_operator markArticleLikeWithArticleID:article.article_id likeNumber:article.like_number];
    [db_operator save];
}
-(void)markArticleCommentsNumberWithArticle:(Article *)article{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    [db_operator markArticleCommentsNumberWithArticleID:article.article_id commentsNumber:article.comments_number];
    [db_operator save];
}
-(Article *)fetchADArticleFromDB{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    Channel* channel=[db_operator fetchADChannel];
    NSArray *articles=[db_operator fetchArticlesWithChannel:channel exceptArticle:nil topN:1];
    if([articles count]>0){
        return [articles objectAtIndex:0];
    }else{
        return nil;
    }
}
-(Channel *)fetchMRCJChannelFromDB{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    return [db_operator fetchMRCJChannel];
}
-(NSArray *)fetchPushArticlesFromDB{
    NSArray *articles=[[_db_manager theForegroundOperator] fetchArticlesThatIsPushed];
    return articles;
}
-(NSArray *)fetchArticlesThatIncludeCoverImage{
    NSArray *articles=[[_db_manager theForegroundOperator] fetchArticlesThatIncludeCoverImage];
    return articles;
}

-(BOOL)hasAuthorized{
    NSLog(@"%@",AppDelegate.user_defaults.sn);
    return AppDelegate.user_defaults.sn.length>0;
}
-(void)likeArticleWithArticle:(Article *)article successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kLikeURL,[XHDeviceInfo udid],article.article_id,AppID];
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
//    NSString *url=[NSString stringWithFormat:kCommentURL,[XHDeviceInfo udid],AppDelegate.user_defaults.sn,article.article_content_id,content,AppID];
//    #define kCommentURL @"http://mis.xinhuanet.com/mif/Common/common_SetComment.ashx?imei=%@&sn=%@&literid=%@&content=%@&appid=%@"
    NSDictionary *variables=[NSDictionary dictionaryWithObjectsAndKeys:[XHDeviceInfo udid],@"imei",AppDelegate.user_defaults.sn,@"sn",article.article_content_id,@"literid",content,@"content",AppID,@"appid",nil];
    [_communicator postVariablesToURL:kCommentURL variables:variables successHandler:^(NSString *responseStr) {
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
    NSDictionary *variables=[NSDictionary dictionaryWithObjectsAndKeys:[XHDeviceInfo udid],@"imei",AppDelegate.user_defaults.sn,@"sn",email,@"email",content,@"content",AppID,@"appid",@"feedback",@"type",nil];
    [_communicator postVariablesToURL:kAppFeedBack  variables:variables  successHandler:^(NSString *responseStr) {
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
    NSString *url=[NSString stringWithFormat:kMMSVeriyCodeURL,[XHDeviceInfo udid],phone_number,AppID];
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
-(void)fetchKeywordsWithSuccessHandler:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:kKeywordsURL,AppID,[XHDeviceInfo udid]];
    [_communicator fetchStringAtURL:url successHandler:^(NSString *responseStr) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *keywords=[_parser parseKeywords:responseStr];;
            DBOperator *db_operator=[_db_manager aBackgroundOperator];
            for(Keyword *keyword in keywords){
                [db_operator addKeyword:keyword];
            }
            [db_operator save];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
                    successBlock(keywords);
                }
            });
        });
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock([NetworkLostError aError]);
        }
    }];
}
-(NSArray *)fetchKeywordsFromDB{
    DBOperator *db_operator=[_db_manager theForegroundOperator];
    return [db_operator fetchKeywords];
}
-(void)checkVersion:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    @try{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _new_version = [[NSMutableDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:KupdateURL]];
            NSLog(@"hasNewerVersion %@",_new_version);
            if(_new_version==nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(errorBlock){
                        errorBlock([NetworkLostError aError]);
                    }
                });
            }else{
                NSMutableDictionary *dic=[((NSMutableArray *)[_new_version objectForKey:@"items"]) objectAtIndex:0];
                NSString *new_version_number=[((NSMutableDictionary *)[dic objectForKey:@"metadata"]) objectForKey:@"bundle-version"];
                NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
                NSString *local_version_number =[infoDict objectForKey:@"CFBundleVersion"];
                NSLog(@"localVersion %@",local_version_number);
                NSLog(@"hasNewerVersion %@",new_version_number);
                BOOL has_new_version=[self versionCompare:local_version_number net:new_version_number];
                if(has_new_version){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(successBlock){
                            successBlock(YES);
                        }
                        NSString *title=[NSString stringWithFormat:@"升级到 %@",[self newVersion]];
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:[self getNewerVersionDescription] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alert.tag=101;
                        [alert show];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(successBlock){
                            successBlock(NO);
                        }
                    });
                }
            }
        });
    }@catch(NSException *e){
        if(errorBlock){
            errorBlock([NetworkLostError aError]);
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self gotoDownload];
    }
}

-(NSString *)newVersion{
    if(_new_version!=nil){
        NSMutableDictionary *dic=[((NSMutableArray *)[_new_version objectForKey:@"items"]) objectAtIndex:0];
        NSString *new_version_number=[((NSMutableDictionary *)[dic objectForKey:@"metadata"]) objectForKey:@"bundle-version"];
        return new_version_number;
    }else
        return @"";
}
-(BOOL)versionCompare:(NSString *)local net:(NSString *)net{
    NSLog(@"lc:%@  sv:%@",local,net);
    NSArray *localArr=[local componentsSeparatedByString:@"."];
    NSArray *netArr=[net componentsSeparatedByString:@"."];
    int local_length=[localArr count];
    int net_length=[netArr count];
    int loop_count=net_length>local_length?net_length:local_length;
    for(int i=0;i<loop_count;i++){
        if([[netArr objectAtIndex:i] intValue]>[[localArr objectAtIndex:i] intValue])
            return YES;
        else if([[netArr objectAtIndex:i] intValue]<[[localArr objectAtIndex:i] intValue])
            return NO;
    }
    return NO;
}
-(NSString *)getNewerVersionDescription{
    if(_new_version==nil)return @"";
    NSMutableDictionary *dic=[((NSMutableArray *)[_new_version objectForKey:@"items"]) objectAtIndex:0];
    NSString *subtitle=[((NSMutableDictionary *)[dic objectForKey:@"metadata"]) objectForKey:@"subtitle"];
    return subtitle;
}
-(void)gotoDownload{
    NSURL *requestURL =[NSURL URLWithString:KDownloadURL];
    [[ UIApplication sharedApplication ] openURL:requestURL];
}
@end
