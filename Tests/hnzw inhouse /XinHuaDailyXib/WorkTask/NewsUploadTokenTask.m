//
//  NewsUploadTokenTask.m
//  CampusNewsLetter
//
//  Created by apple on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsUploadTokenTask.h"
#import "UserDefaultManager.h"
static NewsUploadTokenTask *instance=nil;
@implementation NewsUploadTokenTask
+(NewsUploadTokenTask *)sharedInstance{
    if(instance==nil){
        instance=[[NewsUploadTokenTask alloc]init];
    }
    return instance;
}
-(void)uploadToken:(NSString*)token
{
    NSString* oldToken = [[UserDefaultManager sharedInstance] stringForKey:KUserToken defaultValue:NO];
    if (oldToken.length > 0 && [oldToken isEqualToString:token]) 
    {
        return;
    }
    
    NSString* url = [NSString stringWithFormat:KUploadTokenUrl,[UIDevice customUdid],token];
    NSLog(@"upload Token :%@",url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate=self;
    [request startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString *token = [request.userInfo objectForKey:@"token"];
    [[UserDefaultManager sharedInstance]  setString:token forKey:KUserToken];
    NSDictionary *d = [NSDictionary dictionaryWithObject:@"上传Token成功！"  forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KShowToast object: self userInfo:d];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSDictionary *d = [NSDictionary dictionaryWithObject:@"连接服务器失败，请检查网络连接！"  forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KShowToast object: self userInfo:d];
}
- (void)clearBadgeOnServer{    
    NSString* regUrl = [NSString stringWithFormat:KClearBadgeURL,[UIDevice customUdid]];
    regUrl = [regUrl trimSpaceAndReturn];
    NSLog(@"reg = %@",regUrl);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setCompletionBlock:^{
        
        NSData*   responseData = [request responseData];
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        [responseString release];
        [request release];
    }];
    [request setFailedBlock:^{
        NSLog(@"responseString = %@",[request.error localizedDescription]);
        [request release];
    }];
    [request startAsynchronous];
}


@end
