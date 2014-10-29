//
//  Communicator.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import "Communicator.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NetStreamStatistics.h"
#import "ZipArchive.h"
#import "URLDefine.h"
#import "DeviceInfo.h"
#import "NetworkLostError.h"
@implementation Communicator
- (NSString *)URLEncodedStringWith:(NSString *)original_url
{
    NSString *encoded_url =CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)original_url,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encoded_url;
}
-(BOOL)synBindDevice{
    NSString *url=[NSString stringWithFormat:kBindleDeviceURL,[DeviceInfo udid],[DeviceInfo phoneModel],[DeviceInfo osVersion]];
    url=[self URLEncodedStringWith:url];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
     [request setResponseEncoding:NSUTF8StringEncoding];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSString *responseStr = [request responseString];
        if([responseStr rangeOfString:@"OLD"].location!=NSNotFound||[responseStr rangeOfString:@"NEW"].location!=NSNotFound){
            AppDelegate.user_defaults.has_bind_device_to_server=YES;
            return YES;
        }
    }
    return NO;
}
-(BOOL)checkBinding{
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
    if(![self checkBinding]){
        if(errorBlock!=nil){
            errorBlock([NetworkLostError aError]);
        }
        return;
    }
    url=[self URLEncodedStringWith:url];
    NSLog(@"%@",url);
    ASIHTTPRequest* _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest* request=_request;
    [request setResponseEncoding:NSUTF8StringEncoding];
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
           errorBlock([NetworkLostError aError]);
        }
    }];
    [request startAsynchronous];
}
-(void)fetchFileAtURL:(NSString *)url toPath:(NSString *)path successHandler:(void(^)(BOOL))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    url=[self URLEncodedStringWith:url];
    ASIHTTPRequest* _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest* request=_request;
    [request setResponseEncoding:NSUTF8StringEncoding];
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
            errorBlock([NetworkLostError aError]);
        }
    }];
    [request startAsynchronous];
}
-(void)postVariablesToURL:(NSString *)url variables:(NSDictionary *)variables successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    __weak ASIFormDataRequest* request=_request;
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSEnumerator * enumerator = [variables keyEnumerator];
    id object;
    while(object = [enumerator nextObject])
    {
        id objectValue = [variables objectForKey:object];
        if(objectValue != nil)
        {
            [request setPostValue:objectValue forKey:object];
        }
    }
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
                if(successBlock!=nil){
                    successBlock(responseString);
                }
    }];
    [request setFailedBlock:^{
        if(errorBlock!=nil){
            errorBlock([NetworkLostError aError]);
        }
    }];
    [request startAsynchronous];
}
@end
