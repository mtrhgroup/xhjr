//
//  NewsDownloadExpreesTask.m
//  CampusNewsLetter
//
//  Created by apple on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsDownloadExpreesTask.h"
#import "XDailyItem.h"
#import "ZipArchive.h"
#import "NewsXmlParser.h"
#import "Reachability.h"
#import "NetStreamStatistics.h"
#import "NewsZipReceivedReportTask.h"
static NewsDownloadExpreesTask *instance=nil;
@implementation NewsDownloadExpreesTask
+(NewsDownloadExpreesTask *)sharedInstance{
    if(instance==nil){
        instance=[[NewsDownloadExpreesTask alloc]init];
    }
    return instance;
}
-(void)execute:(NSString *)item_id{   
    XDailyItem* tempItem =[AppDelegate.db GetXdailyByItemId: [NSNumber numberWithInt:item_id.intValue]];
    if(tempItem!=nil) 
    {
        NSDictionary *d = [NSDictionary dictionaryWithObject:tempItem forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KExpressNewsOK object: self userInfo:d];
        return;        
    }    
    NSString*  itemurl =  [NSString stringWithFormat:KXdailyUrlOnlyOne,item_id];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:itemurl]];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:30];
    request.userInfo=[NSDictionary dictionaryWithObjectsAndKeys:item_id, @"item_id", nil];
    [request setDidFinishSelector:@selector(expressNewsXmlCompletion:)];
    [request setDidFailSelector:@selector(expressNewsXMlFailed:)];
    [request startAsynchronous];
}
-(void)expressNewsXmlCompletion:(ASIHTTPRequest *)request{
    NSString *item_id = [request.userInfo objectForKey:@"item_id"];
    NSString *responseString = [request responseString];       
    XDailyItem * xdaily = [NewsXmlParser ParseXDailyItem:responseString];
    xdaily.item_id=[NSNumber numberWithInt:item_id.intValue];
    [self downloadNewsExpress:xdaily];
    [request release];
}
-(void)expressNewsXMlFailed:(ASIHTTPRequest *)request{
    NSDictionary *d = [NSDictionary dictionaryWithObject:@"获取快讯失败！" forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KExpressNewsError  object: self userInfo:d];
    [request release];
}
-(void)saveToDB:(XDailyItem *)xdaily{
    [AppDelegate.db addXDailyItem:xdaily];
    [AppDelegate.db SaveDb];
    XDailyItem* tempItem =[AppDelegate.db GetXdailyByItemId: xdaily.item_id];
    if(tempItem!=nil){
        NSDictionary *d = [NSDictionary dictionaryWithObject:tempItem forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KExpressNewsOK object: self userInfo:d];
    }
}
-(BOOL)downloadNewsExpress:(XDailyItem*) xdaily{
    NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[xdaily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];    
    NSString* fileName = [url lastPathComponent];
    NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
    if ([ AppDelegate.db IsNewsInDb:xdaily])
    {
        NSDictionary *d = [NSDictionary dictionaryWithObject:xdaily forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KExpressNewsOK object: self userInfo:d];
        return false;
    }
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:30];
    [request setDidFinishSelector:@selector(expressNewsZipCompletion:)];
    [request setDidFailSelector:@selector(expressNewsZipFailed:)];
    [request setDownloadDestinationPath:filePath];   
    request.userInfo=[NSDictionary dictionaryWithObjectsAndKeys:filePath,@"file_path",xdaily,@"item",nil];
    [request startAsynchronous];
    return YES;
    
}
-(void)expressNewsZipCompletion:(ASIHTTPRequest *)request{
    int toAdd=(int)request.totalBytesRead;
    [[NetStreamStatistics sharedInstance] appendBytesToDictionary:toAdd];
    NSString *filePath = [request.userInfo objectForKey:@"file_path"];
    XDailyItem *xdaily = [request.userInfo objectForKey:@"item"];
    ZipArchive* zip = [[ZipArchive alloc] init];
    BOOL ret =  [zip UnzipOpenFile:filePath];
    if (ret)
    {
        [zip UnzipFileTo:[filePath stringByDeletingPathExtension] overWrite:YES];
    }        
    [NewsZipReceivedReportTask execute:xdaily];
    [self saveToDB:xdaily];
    [zip release];                                              
    [request release];

}
-(void)expressNewsZipFailed:(ASIHTTPRequest *)request{
    NSDictionary *d = [NSDictionary dictionaryWithObject:@"获取快讯失败！" forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: KExpressNewsError  object: self userInfo:d];
    [request release];
}
@end
