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
    ASIHTTPRequest* _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
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
-(void)postVariablesToURL:(NSString *)url variables:(NSDictionary *)variables successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    
}
@end
