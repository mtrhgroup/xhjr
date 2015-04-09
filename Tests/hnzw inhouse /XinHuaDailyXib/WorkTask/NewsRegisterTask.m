//
//  NewsRegisterTask.m
//  CampusNewsLetter
//
//  Created by apple on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsRegisterTask.h"
#import "UserDefaultManager.h"
#import "NewsDefine.h"
#import "ASIHTTPRequest.h"
#import "NewsXmlParser.h"
#import "NewsUserInfo.h"
static NewsRegisterTask *instance=nil;
@implementation NewsRegisterTask
+(NewsRegisterTask *)sharedInstance{
    if(instance==nil){
        instance=[[NewsRegisterTask alloc]init];
    }
    return instance;
}
-(BOOL)isRegistered{
    NSLog(@"isREgistered %@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode]);
    if([[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode]==nil){
        return NO;
    }else{
        return YES;
    }
}
-(void)execute:(NSString *)authCode{
    NSLog(@"authCode=%@",authCode);
    NSString* regUrl = [NSString stringWithFormat:KBindleSNUrl,[UIDevice customUdid],authCode,[[UIDevice currentDevice] systemVersion]];
    NSLog(@"reg url %@",regUrl);
    regUrl=[regUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
    request.userInfo= [NSDictionary dictionaryWithObject:authCode forKey:@"data"];
    request.delegate=self;
    [request startAsynchronous];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSDictionary *d = [NSDictionary dictionaryWithObject:@"注册失败，请检查网络连接！"
                                                  forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KShowToast
                                                        object: self userInfo:d];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString *responseString = [request responseString];
    NSLog(@"responseString %@",responseString);
    NSString *authCode=[request.userInfo objectForKey:@"data"];
    if([responseString rangeOfString:@"SUCCESSED"].location!=NSNotFound){
        [[UserDefaultManager sharedInstance]  setString:authCode  forKey:KUserDefaultAuthCode];
//        [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        [[NSNotificationCenter defaultCenter] postNotificationName: KBindleSnOK object: nil];
    }else{
        NSDictionary *d = [NSDictionary dictionaryWithObject:@"此手机号尚未注册为会员！"  forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KShowToast  object: self userInfo:d];
    }       
}
-(void)regWith:(NSString *)username company:(NSString *)company telphone:(NSString *)telphone{
    NSString* regUrl = [NSString stringWithFormat:KRegNewUserUrl,[UIDevice customUdid],telphone,username,company,[[UIDevice currentDevice] systemVersion]];
    NSLog(@"%@",regUrl);
    regUrl=[regUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",regUrl);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        if([responseString hasPrefix:@"SUCCESS"])
            [[NSNotificationCenter defaultCenter] postNotificationName: KUserRegOK object: nil];
    }];
    [request setFailedBlock:^{
        
        NSDictionary *d = [NSDictionary dictionaryWithObject:@"提交失败"  forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KRegWrong  object: self userInfo:d];
        //[self doneLoadingTableViewData];
    }];
    [request startAsynchronous];
}
-(void)getUserInfo:(NSString *)authCode{
    NSLog(@"authCode=%@",authCode);
    NSString* regUrl = [NSString stringWithFormat:KUserInfo,authCode];
    regUrl=[regUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
    request.delegate=self;
    [request setDidFinishSelector:@selector(getUserInfoCompletion:)];
    [request setDidFailSelector:@selector(getUserInfoFailed:)];
    [request startAsynchronous];
}
-(void)getUserInfoCompletion:(ASIHTTPRequest *)request{
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    NewsUserInfo *user_info=[NewsXmlParser ParseUserInfo:responseString];
    if(user_info!=nil){
    NSLog(@"parser OK name%@",user_info.name);
    NSLog(@"parser OK sn%@",user_info.sn);
    NSLog(@"parser OK collage%@",user_info.company);
    NSLog(@"parser OK school%@",user_info.description);
    NSDictionary *d = [NSDictionary dictionaryWithObject:user_info forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KUserInfoReady
                                                        object: self userInfo:d];
    }else{
        NSDictionary *d = [NSDictionary dictionaryWithObject:@"所选高校不存在该授权码，请确认学校选择和授权码是否正确。"  forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KShowToast  object: self userInfo:d];
    }
}
-(void)getUserInfoFailed:(ASIHTTPRequest *)request{
    NSDictionary *d = [NSDictionary dictionaryWithObject:@"请检查网络连接"  forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KShowToast  object: self userInfo:d];
}
@end
