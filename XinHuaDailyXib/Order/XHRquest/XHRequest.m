//
//  XHRequest.m
//  YourOrder
//
//  Created by 胡世骞 on 14/12/2.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "XHRequest.h"
NSString *const kAPI_BASE_URL = @"http://mis.xinhuanet.com/SXTV2/Mobile/Interface/";
@implementation XHRequest
+(XHRequest*)shareInstance
{
    static XHRequest *httpUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpUtil = [[XHRequest alloc]init];
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
- (ASIHTTPRequest *)POST_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.requestMethod = @"POST";
    
    [paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setPostValue:obj forKey:key];
    }];
    
    [request setCompletionBlock:^{
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completeBlock(jsonData,request.responseString);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    kNSLog(@"ASIClient POST: %@ %@",[request url],paramsDic);
    
    return request;
}
@end
