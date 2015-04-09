//
//  NewsDownloadImgTask.m
//  CampusNewsLetter
//
//  Created by apple on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsDownloadImgTask.h"
#import "NewsDefine.h"
#import "ASIHTTPRequest.h"
#import "CommonMethod.h"
@implementation NewsDownloadImgTask

+(void)execute{
    NSString* authcode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode];
    NSString* picURL = [NSString stringWithFormat:KWelcomePictureURL,authcode];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:picURL]];
    [request setDidFinishSelector:@selector(loadPicXmlCompletion:)];
    [request setDidFailSelector:@selector(loadPicXmlFailed:)];
    request.delegate=self;
    [request startAsynchronous];
}
+(void)loadPicXmlCompletion:(ASIHTTPRequest *)request{
    NSString *responseString = [request responseString];
    NSString*  url = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]; 
    NSString* filePath = [CommonMethod fileWithDocumentsPath:url];
    if([url isEqualToString:@""])return;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        //[self addSubImgView:filePath];
        NSDictionary *d = [NSDictionary dictionaryWithObject:filePath
                                                      forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KPictureOK
                                                            object: self userInfo:d];
    }else{
        [self GetImgFromWeb:url];
    }
}
+(void)loadPicXmlFailed:(ASIHTTPRequest *)request{
    
}
+(void)GetImgFromWeb:(NSString *)url
{
    NSString* filePath = [CommonMethod fileWithDocumentsPath:url];
    NSString*  web_url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,url];
    web_url=[web_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSFileManager* fm = [NSFileManager defaultManager];   
    if ( ![fm fileExistsAtPath:[[filePath stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]] ) {
        [fm createDirectoryAtPath:[[filePath stringByDeletingLastPathComponent] stringByDeletingLastPathComponent] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ( ![fm fileExistsAtPath:[filePath stringByDeletingLastPathComponent]] ) {
        [fm createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return;
    }   
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:web_url]];
    request.downloadDestinationPath = [NSString stringWithFormat:@"%@%@", filePath,@"tmp"];
    [request setDidFinishSelector:@selector(loadPicImgCompletion:)];
    [request setDidFailSelector:@selector(loadPicImgFailed:)];
    NSDictionary *d = [NSDictionary dictionaryWithObject:filePath forKey:@"file_path"];
    request.userInfo=d;
    request.delegate=self;

    [request startAsynchronous];
}

+(void)loadPicImgCompletion:(ASIHTTPRequest *)request{
    NSString *filePath = [request.userInfo objectForKey:@"file_path"];
    NSLog(@"filePath %@",filePath);
    [[NSFileManager  defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@%@", filePath,@"tmp"]  toPath:filePath error:nil];
    //[self addSubImgView:filePath]; 
    NSDictionary *d = [NSDictionary dictionaryWithObject:filePath
                                                  forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KPictureOK
                                                        object: self userInfo:d];
    // [self removeRequestFromQueue];
    //    _downloading = NO;
}
+(void)loadPicImgFailed:(ASIHTTPRequest *)request{

}

@end
