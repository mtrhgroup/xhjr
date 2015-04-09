//
//  XHRequest.m
//  YourOrder
//
//  Created by 胡世骞 on 14/12/2.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "XHRequest.h"
#import "Communicator.h"
NSString *const kAPI_BASE_URL = @"http://mis.xinhuanet.com/mif/Common/";
@implementation XHRequest
static Communicator *communicator=nil;
+(XHRequest*)shareInstance
{
    static XHRequest *httpUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpUtil = [[XHRequest alloc]init];
        communicator=[[Communicator alloc] init];
    });
    return httpUtil;
}
- (ASIHTTPRequest *)GET_Path:(NSString *)path completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"GET";
    [request setCompletionBlock:^{
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completeBlock(jsonData,request.responseString);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    kNSLog(@"ASIClient GET: %@",[request url]);
    
    return request;
}

//- (ASIHTTPRequest *)GET_Path:(NSString *)path completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    request.requestMethod = @"GET";

//    [request setCompletionBlock:^{
//        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
//        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
//        completeBlock(jsonData,request.responseString);
//    }];
//    
//    [request setFailedBlock:^{
//        failed([request error]);
//    }];
//    
//    [request startAsynchronous];
//    
//    kNSLog(@"ASIClient GET: %@",[request url]);
//    
//    return request;
//}
- (ASIHTTPRequest *)POST_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [communicator postVariablesToURL:urlStr variables:paramsDic successHandler:^(NSString *responseStr) {
        NSData *responseData=[responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:responseData  options:0 error:&errorForJSON];
        completeBlock(jsonData,responseStr);
    } errorHandler:^(NSError *error) {
        failed(error);
    }];
    return nil;
}
@end
