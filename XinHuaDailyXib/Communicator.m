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
#import "ZipArchive.h"
#import "URLDefine.h"
#import "DeviceInfo.h"
@implementation Communicator
-(BOOL)synBindDevice{
    NSString *url=[NSString stringWithFormat:kBindleDeviceURL,[DeviceInfo udid],[DeviceInfo phoneModel],[DeviceInfo osVersion]];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSString *responseStr = [request responseString];
        if([responseStr rangeOfString:@"OLD"].location!=NSNotFound||[responseStr rangeOfString:@"NEW"].location!=NSNotFound){
            return YES;
        }
    }
    return NO;
}
-(BOOL)check{
    if(AppDelegate.user_defaults.has_bind_device_to_server){
        return YES;
    }else{
        if([self synBindDevice]){
            return YES;
        }else{
            return NO;
        }
    }
}
-(void)fetchStringAtURL:(NSString *)url successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    if(![self check])return;
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
        ZipArchive* zip = [[ZipArchive alloc] init];
        BOOL ret =  [zip UnzipOpenFile:path];
        if (ret)
        {
            if([zip UnzipFileTo:[path stringByDeletingPathExtension] overWrite:YES]){
                if(successBlock!=nil){
                    successBlock(YES);
                }
            }
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
