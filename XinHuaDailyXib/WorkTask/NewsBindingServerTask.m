//
//  NewsBindingServerTask.m
//  CampusNewsLetter
//
//  Created by apple on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsBindingServerTask.h"
#import "NewsDefine.h"
#import "ASIHTTPRequest.h"
@implementation NewsBindingServerTask

+(void)execute{
    NSString *bindphone_url=[NSString stringWithFormat:KBindlePhoneUrl,[UIDevice customUdid],[[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion],sxttype,sxtversion];
    bindphone_url=[bindphone_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",bindphone_url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:bindphone_url]];
    request.delegate=self;
    [request startAsynchronous];
}
+(void)requestFinished:(ASIHTTPRequest *)request{
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    NSDictionary *d;
    NSRange range=[responseString rangeOfString:@"OLD"];
    [[NSUserDefaults standardUserDefaults] setObject:@"imei" forKey:[UIDevice customUdid]];
    if(range.location!=NSNotFound){        
        if(responseString.length>3){
            NSString *snStr=[responseString substringFromIndex:4];
           [[NSUserDefaults standardUserDefaults]  setObject:snStr  forKey:KUserDefaultAuthCode];
            d = [NSDictionary dictionaryWithObject:@"old"  forKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName: KBindlePhoneOK
                                                                object: self userInfo:d];
        }else{
            d = [NSDictionary dictionaryWithObject:@"new"  forKey:@"data"];
            [[NSUserDefaults standardUserDefaults]  setObject:nil  forKey:KUserDefaultAuthCode];
            [[NSNotificationCenter defaultCenter] postNotificationName: KBindlePhoneFailed
                                                                object: self userInfo:d];
        }
        
    }else{
        d = [NSDictionary dictionaryWithObject:@"new"  forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KBindlePhoneFailed
                                                            object: self userInfo:d];
    }
 
}

+(void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"error = %@",[error localizedDescription]);
    NSDictionary *d = [NSDictionary dictionaryWithObject:@"连接服务器失败，请检查网络连接！"
                                                  forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KBindlePhoneFailed
                                                        object: self userInfo:d];
}

@end
