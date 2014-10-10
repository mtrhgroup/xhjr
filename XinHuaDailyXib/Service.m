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
#import "URLDefine.h"
@implementation Service{
    Communicator *_communicator;
    Parser *_parser;
    DBManager *_db_manager;
}
-(id)init{
    if(self=[super init]){
        _communicator=[[Communicator alloc]init];
        _db_manager=[[DBManager alloc] init];
        _parser=[[Parser alloc] init];
    }
    return self;
}
//网络
-(void)fetchChannelsFromNET:(void(^)(NSArray *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:channel_list_url,[KidsOpenUDID value], kindergartenid]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary *jsonString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *error=nil;
            NSArray *channels=[_parser channelsFromJSON:jsonString error:&error];
            KidsDBOperator *db_operator=[_db_manager aOperator];
            if([channels count]>0){
                [db_operator removeAllChannels];
            }
            [db_operator save];
            for(KidsChannel *channel in channels){
                [db_operator addChannel:channel];
            }
            [db_operator save];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(successBlock){
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
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:article_list_url,[KidsOpenUDID value], kindergartenid,[self fetchClassIDFromLocal],channelID,pageIndex,countPerPage]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * jsonString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *error=nil;
            NSArray *articles=[_parser articlesFromJSON:jsonString error:&error];
            KidsDBOperator *db_operator=[_db_manager aOperator];
            for(KidsArticle *article in articles){
                article.channel_id=channelID;
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
-(void)registerDevice:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:reg_url,[KidsOpenUDID value], kindergartenid,[self phoneModel],[self osVersion], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * response) {
        NSError *error=nil;
        BOOL isOK=[_parser invalidateJSONWith:response error:&error];
        if(successBlock){
            [[UserActionsController sharedInstance] enqueueARegisterAction:[NSString stringWithFormat:@"%@ iOS %@",[self phoneModel],[self osVersion]]];
            successBlock(isOK);
        }
        
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)registerSNWithSN:(NSString *)SN successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *tempURL=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:enroll_class_url,[KidsOpenUDID value],kindergartenid,kidsclass.class_id,phone,username]];
    NSString *url=[tempURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * response) {
        NSError *error=nil;
        BOOL isOK=[_parser invalidateJSONWith:response error:&error];
        if(isOK){
            NSString *old_class_id=[self fetchClassIDFromLocal];
            FrontiaPush *push=[Frontia getPush];
            [push delTag:old_class_id tagOpResult:^(int count, NSArray *failureTag) {
                // <#code#>
            } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
                //  <#code#>
            }];
            [push setTag:[NSString stringWithFormat:@"%@",kidsclass.class_id] tagOpResult:^(int count, NSArray *failureTag) {
                // <#code#>
            } failureResult:^(NSString *action, int errorCode, NSString *errorMessage) {
                //  <#code#>
            }];
            [self saveUserInfo:username userphone:phone classid:kidsclass.class_id];
            [[UserActionsController sharedInstance] enqueueAEnrollmentAction:kidsclass];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(successBlock){
                successBlock(isOK);
            }
        });
        
    } errorHandler:^(NSError *error) {
        [self saveUserInfo:username userphone:phone classid:@"0"];
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchAppCoverImage:(void(^)(UIImage *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:startup_image_url,[KidsOpenUDID value],kindergartenid]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * response) {
        NSError *error=nil;
        KidsAppCoverImage *image=[_parser  setupImageFromJSON:response error:&error];
        [self saveAppCoverImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(successBlock){
                successBlock(image);
            }
        });
        
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)saveAppCoverImage:(KidsAppCoverImage *)appCoverImage{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:appCoverImage];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SetupImage"];
}
-(KidsAppCoverImage *)fetchAppCoverImage{
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"SetupImage"];
    KidsAppCoverImage *setup_image = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(setup_image==nil)setup_image=[[KidsAppCoverImage alloc]init];
    return setup_image;
}
-(void)executeModifyActions:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *imei=[KidsOpenUDID value];
    NSString *timeStamp=[self getDeleteTimeStamp];
    NSString *tempURL=[NSString stringWithFormat:delete_url,imei,kindergartenid,channelID,timeStamp ];
    NSString *url=[[NSString stringWithFormat:@"%@%@",url_prefix,tempURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * response) {
        NSError *error=nil;
        NSArray *articleIDs=[_parser toDeleteArticleIDsFromJSON:response error:&error];
        if(!error){
            [self saveDeleteTimeStamp];
        }
        KidsDBOperator *db_operator=[_db_manager aOperator];
        BOOL hasDeleted=[db_operator deleteArticleWithArticleIDs:articleIDs];
        [db_operator save];
        if(successBlock){
            successBlock(hasDeleted);
        }
        
    } errorHandler:^(NSError *error) {
        if(errorBlock){
            errorBlock(error);
        }
    }];
}
-(void)fetchArticlesForHomeVC:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    
}
-(void)reportActionsToServer:(NSString *)postJSON succcessHander:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:push_article_url,[KidsOpenUDID value],articleID]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * jsonString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *error=nil;
            KidsArticle *article=[_parser pushArticleFromJSON:jsonString error:&error];
            KidsDBOperator *db_operator=[_db_manager aOperator];
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
-(void)fetchPushArticleWithArticleID:(NSString *)articleID successHandler:(void(^)(Article *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *url=[NSString stringWithFormat:@"%@%@",url_prefix,[NSString stringWithFormat:push_article_url,[KidsOpenUDID value],articleID]];
    [_communicator fetchJSONContentAtURL:url successHandler:^(NSDictionary * jsonString) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *error=nil;
            KidsArticle *article=[_parser pushArticleFromJSON:jsonString error:&error];
            KidsDBOperator *db_operator=[_db_manager aOperator];
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
    for (KidsChannel* ch in channels) {
        [res addObject:ch];
    }
    return res;
}
-(NSArray *)fetchLeafChannelsFromDBWithTrunkChannel:(Channel *)channel{
    
}
-(NSArray *)fetchArticlesFromDBWithChannel:(Channel *)channel topN:(int)topN{
    NSArray *articles=[[_db_manager aOperator] fetchMutiCoverImageArticlesWithChannel:channel topN:2];
    NSMutableArray *array_ids=[[NSMutableArray alloc] init];
    for(KidsArticle *article in articles){
        [array_ids addObject:article.article_id];
    }
    if(exceptArticleID!=nil&&![exceptArticleID isEqual:@""]){
        [array_ids insertObject:exceptArticleID atIndex:0];
    }
    NSArray * articles_only_thumail=[[_db_manager aOperator] fetchArticlesWithChannel:channel exceptArticleID:array_ids topN:topN];
    NSMutableArray *res=[[NSMutableArray alloc] init];
    [res addObjectsFromArray:articles_only_thumail];
    if(articles!=nil&&[articles count]>0){
        if([res count]>=5)
            [res insertObject:articles[0] atIndex:5];
        else
            [res addObject:articles[0]];
    }
    if(articles!=nil&&[articles count]>1){
        if([res count]>=10)
            [res insertObject:articles[1] atIndex:10];
        else
            [res addObject:articles[1]];
        
    }
    return res;
}
-(void)markArticleFavorInDB:(Article *)article favor:(BOOL)favor{
    if(favor){
        [[UserActionsController sharedInstance] enqueueACollecionAction:article];
    }
    KidsDBOperator *db_operator=[_db_manager aOperator];
    [db_operator markArticleFavorWithArticleID:article.article_id favor:favor];
    [db_operator save];
}
-(void)markArticleReadWithArticleInDB:(Article *)article{
    [[UserActionsController sharedInstance] enqueueAReadAction:article];
    KidsDBOperator *db_operator=[_db_manager aOperator];
    [db_operator markArticleReadWithArticleID:article.article_id];
    [db_operator save];
}
-(Article *)fetchADArticleFromDB{
    DBOperator *db_operator=[_db_manager aOperator];
    Channel* channel=[db_operator fetchADInContentChannel];
    NSArray *articles=[db_operator fetchArticlesWithChannel:channel exceptArticle:nil topN:1];
    if([articles count]>0){
        return [articles objectAtIndex:0];
    }else{
        return nil;
    }
}
-(NSArray *)fetchPushArticlesFromDB{
    KidsChannel* channel=[[_db_manager aOperator] fetchNotificationChannel];
    return channel;
}

//配置
-(NSString *)getFontSize{
    NSString *fontSize=[[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"];
    if(fontSize==nil){
        return @"正常";
    }else{
        return fontSize;
    }
}
-(void)saveFontSize:(NSString *)fontSize{
     [[NSUserDefaults standardUserDefaults] setObject:fontSize forKey:@"fontSize"];
}
@end
