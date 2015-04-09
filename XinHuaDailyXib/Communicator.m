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
#import "XHDeviceInfo.h"
#import "NetworkLostError.h"
#import "Cryptor.h"
#import "Util.h"
@interface Communicator()
@property(nonatomic,strong)Cryptor *cryptor;
@property(nonatomic,strong)NSString *redirect_url;
@end
    
@implementation Communicator
-(id)init{
    if(self=[super init]){
        self.cryptor=[[Cryptor alloc] init];
        self.redirect_url=@"http://mis.xinhuanet.com/mif/mifredirect.ashx";
    }
    return self;
}
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
    NSString *url=[NSString stringWithFormat:kBindleDeviceURL,[XHDeviceInfo udid],[XHDeviceInfo phoneModel],[XHDeviceInfo osVersion],AppID];
//    url=[self URLEncodedStringWith:url];
//    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest*request=[self makeHTTPRequest:url vars:nil];
     [request setResponseEncoding:NSUTF8StringEncoding];
    request.shouldAttemptPersistentConnection   = NO;
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

-(ASIHTTPRequest *)makeHTTPRequest:(NSString *)url vars:(NSDictionary *)vars{
    NSString *method=[url substringFromIndex:24];
    NSString *method_data;
    if(vars==nil){
       NSString *encode_url=[self URLEncodedStringWith:method];
       method_data=[self.cryptor AES256_Encrypt:encode_url];
    }else{
        NSMutableString *parameters=[[NSMutableString alloc] initWithFormat:@"%@?",method];
        
        NSEnumerator * enumerator = [vars keyEnumerator];
        id object;
        while(object = [enumerator nextObject])
        {
            id objectValue = [vars objectForKey:object];
            if(objectValue != nil)
            {
                [parameters appendFormat:@"%@=%@&",object,[Util URLEncodedStringWith:(NSString *)objectValue]];
            }
        }
      NSString *p=[parameters substringToIndex:parameters.length-1];
         method_data=[self.cryptor AES256_Encrypt:p];
    }
     ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:self.redirect_url]];
    [request setPostValue:method_data forKey:@"method"];
    return request;
}

-(void)fetchStringAtURL:(NSString *)url successHandler:(void(^)(NSString *))successBlock errorHandler:(void(^)(NSError *))errorBlock{
    if(![self checkBinding]){
        if(errorBlock!=nil){
            errorBlock([NetworkLostError aError]);
        }
        return;
    }
    __weak ASIHTTPRequest*request=[self makeHTTPRequest:url vars:nil];
//    NSLog(@"%@",url);
//    ASIHTTPRequest* _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    __weak ASIHTTPRequest* request=_request;
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
//    ASIHTTPRequest*request=[self makeHTTPRequest:url vars:nil];
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
//    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    ASIFormDataRequest*_request=(ASIFormDataRequest *)([self makeHTTPRequest:url vars:variables]);
    __weak ASIFormDataRequest* request=_request;
    [request setResponseEncoding:NSUTF8StringEncoding];
//    NSEnumerator * enumerator = [variables keyEnumerator];
//    id object;
//    while(object = [enumerator nextObject])
//    {
//        id objectValue = [variables objectForKey:object];
//        if(objectValue != nil)
//        {
//            [request setPostValue:objectValue forKey:object];
//        }
//    }
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
