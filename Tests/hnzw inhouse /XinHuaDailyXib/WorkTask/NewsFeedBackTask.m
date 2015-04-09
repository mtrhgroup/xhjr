//
//  NewsFeedBackTask.m
//  CampusNewsLetter
//
//  Created by apple on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsFeedBackTask.h"
#import "ASIFormDataRequest.h"
static NewsFeedBackTask *instance=nil;
@implementation NewsFeedBackTask
+(NewsFeedBackTask *)sharedInstance{
    if(instance==nil){
        instance=[[NewsFeedBackTask alloc]init];
    }
    return instance;
}
-(void)execute:(NSString *)authcode emailStr:(NSString *)emailStr contentStr:(NSString *)contentStr{
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:KResponseURL]];
    [request setPostValue:[UIDevice customUdid] forKey:@"imei"];
    [request setPostValue:authcode forKey:@"sn"];
    [request setPostValue:emailStr forKey:@"email"];
    [request setPostValue:contentStr forKey:@"content"];
    request.delegate=self;
    [request startAsynchronous];
}
-(void)requestStarted:(ASIHTTPRequest *)request{

}
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *d = [NSDictionary dictionaryWithObject:@"反馈意见提交成功！感谢您的支持！"
                                                  forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KShowToast
                                                        object: self userInfo:d];
//    [self.view hideToastActivity];
//    NSString *responseString = [request responseString];
//    NSLog(@"OK = %@",responseString);
//    [self.view makeToast:@"反馈意见提交成功！感谢您的支持！"
//                duration:2.0
//                position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
//    [request release];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSDictionary *d = [NSDictionary dictionaryWithObject:@"反馈意见提交失败！"
                                                  forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KShowToast
                                                        object: self userInfo:d];
    
//    [self.view hideToastActivity];
//    NSError *error = [request error];
//    NSLog(@"error = %@",[error localizedDescription]);
//    [self.view makeToast:@"反馈意见提交失败！"
//                duration:2.0
//                position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
//    [request release];
}
@end
