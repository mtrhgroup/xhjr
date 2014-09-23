//
//  NewsCommunicator.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import "NewsNetOperator.h"
#import "NewsXmlParser.h"
#import "ZipArchive.h"
#import "NetStreamStatistics.h"
#import "ASIHTTPRequest.h"

#define KXdailyUrl @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_newperiodicals.ashx?imei=%@&n=%@&pid=%@"
#define KLabelUrl @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_periodicallist.ashx?imei=%@"
@implementation NewsNetOperator
-(NSArray *)downloadXdailyWithChannelId:(NSString *)channel_id topN:(NSString *)topN{    
    NSString *url=[NSString stringWithFormat:KXdailyUrl,[UIDevice customUdid],topN,channel_id];
    NSLog(@"%@",url);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request startSynchronous];
    NSError *err=[request error];
    __autoreleasing NSMutableArray * items=[[NSMutableArray alloc] init];
    if(!err){
        NSString *responseString = [request responseString];
        items = (NSMutableArray *)[NewsXmlParser ParseXDailyItems:responseString];        
    }
//    for(XDailyItem * item in items){
//        if(item.attachments!=nil){
//            [self downloadAttachmentsWith:item];
//        }
//    }
    return items;
}
-(void)downloadDataForMainView{
    
}
-(void)downloadAttachmentsWith:(XDailyItem *)item
{
    NSArray *arr=[item.attachments componentsSeparatedByString:@";"];
    for(NSString *urlstr in arr){
        NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[urlstr stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        NSString* fileName = [url lastPathComponent];
        NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
        NSLog(@"###%@",filePath);
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            break;
        }
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.downloadDestinationPath = [NSString stringWithFormat:@"%@%@", filePath,@"tmp"];
        [request startSynchronous];
        NSError *err=[request error];
        if(!err){
            [[NSFileManager  defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@%@", filePath,@"tmp"]  toPath:filePath error:nil];
        }
    }
}
-(NSArray *)downloadChannelList{
    NSString* url = [NSString stringWithFormat:KLabelUrl,[UIDevice customUdid]];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request startSynchronous];
    NSError *err=[request error];
    NSMutableArray * items=[[NSMutableArray alloc] init];
    if(!err){
        NSString *responseString = [request responseString];
        items = (NSMutableArray *)[NewsXmlParser ParseChannels:responseString];
    }
    return items;
}
-(NSString *)downloadIconfileWithChannelAndReturnFilepath:(NewsChannel *)channel
{
    NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[channel.imgPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    NSString* fileName = [url lastPathComponent];
    NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return filePath;
    }
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.downloadDestinationPath = [NSString stringWithFormat:@"%@%@", filePath,@"tmp"];
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        [[NSFileManager  defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@%@", filePath,@"tmp"]  toPath:filePath error:nil];
        return filePath;
    }
    return nil;
}
-(BOOL)downloadXdaily:(XDailyItem *)xdaily{
    NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[xdaily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    NSString* fileName = [url lastPathComponent];
    NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.downloadDestinationPath = filePath;
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        int toAdd=(int)request.totalBytesRead;
        [[NetStreamStatistics sharedInstance]
         appendBytesToDictionary:toAdd];
        ZipArchive* zip = [[ZipArchive alloc] init];
        BOOL ret =  [zip UnzipOpenFile:filePath];
        if (ret)
        {
            [zip UnzipFileTo:[filePath stringByDeletingPathExtension] overWrite:YES];
        }
        return YES;
    }
    return NO;
}
-(BOOL)downloadPictureWithLocalpath:(NSString *)localpath neturl:(NSString *)neturl{
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:neturl]];
    request.downloadDestinationPath = [NSString stringWithFormat:@"%@%@", localpath,@"tmp"];
    [request startSynchronous];
    NSError *err=[request error];
    if(!err){
        [[NSFileManager  defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@%@", localpath,@"tmp"]  toPath:localpath error:nil];
        return YES;
    }
    return NO;
}
@end
