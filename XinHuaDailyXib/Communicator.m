//
//  Communicator.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import "Communicator.h"
#import "ASIHTTPRequest.h"
#import "NetStreamStatistics.h"
@implementation Communicator
-(void)fetchStringAtURL:(NSString *)url successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    NSString *bindphone_url=[NSString stringWithFormat:url,[UIDevice customUdid],[[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion],sxttype,sxtversion];
    bindphone_url=[bindphone_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",bindphone_url);
    ASIHTTPRequest* _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:bindphone_url]];
    __weak ASIHTTPRequest* request=_request;
    [request setCompletionBlock:^{
        int toAdd=(int)request.totalBytesRead;
        [[NetStreamStatistics sharedInstance] appendBytesToDictionary:toAdd];
        if(successBlock!=nil){
            NSString *responseString = [request responseString];
            NSLog(@"%@",responseString);
            successBlock(responseString);
        }
        
    }];
    [request setFailedBlock:^{
        if(errorBlock!=nil){
            NSError *error = [request error];
            errorBlock(error);
        }
    }];
    [request startAsynchronous];
}
-(void)fetchFileAtURL:(NSString *)url toPath:(NSString *)path successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    ASIHTTPRequest* _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest* request=_request;
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:30];
    request.downloadDestinationPath = path;
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@"%@",responseString);
        if(successBlock!=nil){
            successBlock(YES);
        }
    }];
    [request setFailedBlock:^{
        if(errorBlock!=nil){
            NSError *error = [request error];
            errorBlock(error);
        }
    }];
    [request startAsynchronous];
}
-(void)postJSONToURL:(NSString *)url parameters:(NSDictionary *)parameters successHandler:(void(^)(NSDictionary *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    
}
@end
