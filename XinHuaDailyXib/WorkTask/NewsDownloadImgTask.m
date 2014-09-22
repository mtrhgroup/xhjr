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
#import "VersionInfo.h"
#import "NewsXmlParser.h"
#import "NetStreamStatistics.h"
#import "ZipArchive.h"
#import "NewsZipReceivedReportTask.h"
static NewsDownloadImgTask *instance;
@implementation NewsDownloadImgTask{
    VersionInfo *version_info_net;
}
+(NewsDownloadImgTask *)sharedInstance{
    if(instance==nil){
        instance=[[NewsDownloadImgTask alloc]init];
    }
    return instance;
}
-(void)execute{
    NSString* authcode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode];
    NSString* picURL = [NSString stringWithFormat:KVersionInfo,authcode];
    NSLog(@"picURL %@",picURL);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:picURL]];
    [request setDidFinishSelector:@selector(loadPicXmlCompletion:)];
    [request setDidFailSelector:@selector(loadPicXmlFailed:)];
    request.delegate=self;
    [request startAsynchronous];
}
NSString *pid_net;
-(void)loadPicXmlCompletion:(ASIHTTPRequest *)request{
        NSString *responseString = [request responseString];
        NSLog(@"responseString %@",responseString);
    
        @try{
            version_info_net=[NewsXmlParser ParseVersionInfo:responseString];
            [self updateLocalVersionInfo:version_info_net];
            if(version_info_net.gid==nil){
                return;
            }
            if([self hasNewerCoverArticle]){
                [self loadAdvXMLWith:version_info_net.gid];
            }
        }@catch(NSException *e){
            NSLog(@"版本信息解析失败！");
        }
}
-(void)loadAdvXMLWith:(NSString *)gid{
    
    NSString*  itemurl =  [NSString stringWithFormat:KXdailyUrlOnlyOne,gid,[UIDevice customUdid]];
    NSLog(@"itemurl = %@",itemurl);
    ASIHTTPRequest* myrequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:itemurl]];
    [myrequest setShouldAttemptPersistentConnection:NO];
    [myrequest setTimeOutSeconds:30];
    myrequest.defaultResponseEncoding = NSUTF8StringEncoding;
    [myrequest setCompletionBlock:^{
        NSString *responseString = [myrequest responseString];
        NSLog(@"responseString = %@",responseString);
        XDailyItem * xdaily = [NewsXmlParser ParseXDailyItem:responseString];
        if(xdaily==nil||xdaily.item_id==nil||[xdaily.item_id intValue]==0)return;
        xdaily.item_id=[NSNumber numberWithInt:gid.intValue];
        
        [self downloadNewsExpress:xdaily];
    }];
    
    
    [myrequest setFailedBlock:^{
        NSError *error = [myrequest error];
        NSLog(@"error = %@",[error localizedDescription]);
    }];
    [myrequest startAsynchronous];
}
-(BOOL)downloadNewsExpress:(XDailyItem*) xdaily{
    NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[xdaily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    NSString* fileName = [url lastPathComponent];
    NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
    NSLog(@"%@",filePath);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:30];
    [request setCompletionBlock:^{
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
        [self updateLocalAdvInfo:xdaily];
    }];
    [request setFailedBlock:^{
        NSDictionary *d = [NSDictionary dictionaryWithObject:@"获取快讯失败！" forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName: KExpressNewsError  object: self userInfo:d];
    }];
    [request setDownloadDestinationPath:filePath];
    request.userInfo=[NSDictionary dictionaryWithObjectsAndKeys:filePath,@"file_path",xdaily,@"item",nil];
    [request startAsynchronous];
    return YES;
    
}
-(BOOL)hasNewerCoverArticle{
    VersionInfo *local_version=[self getLocalVersionInfo];
    if(local_version==nil){
        return YES;
    }
    if([local_version.gid isEqualToString:version_info_net.gid]){
        return NO;
    }else{
        return YES;
    }
}
-(void)updateLocalVersionInfo:(VersionInfo *)version_info{
    VersionInfo *local_version=[self getLocalVersionInfo];
    local_version.groupTitle=version_info.groupTitle;
    local_version.groupSubTitle=version_info.groupSubTitle;
    [self setLocalVersionInfo:local_version];
}

-(void)updateLocalAdvInfo:(XDailyItem *)xdaily{
    //[self clearOldAdvPath:version_info_net.advPath];
    VersionInfo *local_version=[self getLocalVersionInfo];
    local_version.gid=version_info_net.gid;
    local_version.advPagePath=[self getAdvPagePath:xdaily];
    local_version.advPath=[self getAdvPath:xdaily];
    local_version.startImgUrl=[self getStartImagePath:xdaily];
    [self setLocalVersionInfo:local_version];
}
-(NSString *)getAdvPath:(XDailyItem *)item{
    NSString* url = [item.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString* fileName = [[url lastPathComponent] stringByDeletingPathExtension] ;
    NSString* advPath = [CommonMethod fileWithDocumentsPath:fileName];
    return advPath;
}
-(NSString *)getStartImagePath:(XDailyItem *)item{
    NSString *imagePath;
    if(item.attachments!=nil){
        NSArray* tmpArray=[item.attachments componentsSeparatedByString:@";"];
        NSString *picturefilename=[[[tmpArray objectAtIndex:0]  stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent];
        imagePath=[[[[item localPath] stringByDeletingLastPathComponent] stringByAppendingString:@"/Imgs/"]  stringByAppendingString:picturefilename];
    }
    if(item.thumbnail!=nil){
        NSLog(@"original thumbnail url%@",item.thumbnail);
        NSString *thumbnail_file=[[item.thumbnail stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent];
        imagePath=[[[[item localPath] stringByDeletingLastPathComponent] stringByAppendingString:@"/Imgs/"]  stringByAppendingString:thumbnail_file];
    }

    return imagePath;
}
-(NSString *)getAdvPagePath:(XDailyItem *)item{
    return [item localPath];
}

-(void)clearOldAdvPath:(NSString *)filePath{
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:filePath error:nil];
        NSLog(@"filePath______==%@",filePath);
}
-(VersionInfo *)getLocalVersionInfo{
    NSData *old_data=[[NSUserDefaults standardUserDefaults]objectForKey:@"version_info"];
    VersionInfo *version_info_local=[NSKeyedUnarchiver unarchiveObjectWithData:old_data];
    if(version_info_local==nil){
        VersionInfo *newVersionInfo=[[VersionInfo alloc] init];
        [self setLocalVersionInfo: newVersionInfo];
    }
    return version_info_local;
}
-(void)setLocalVersionInfo:(VersionInfo *)version_info{
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:version_info];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"version_info"];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"KVersionInfoOK" object: self userInfo:nil];
}


-(void)loadPicXmlFailed:(ASIHTTPRequest *)request{
    
}
-(void)GetImgFromWeb:(NSString *)url
{
    NSString* filePath = [CommonMethod fileWithDocumentsPath:url];
    NSString*  web_url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,url];
    NSLog(@"$$%@",web_url);
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

-(void)loadPicImgCompletion:(ASIHTTPRequest *)request{
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
-(void)loadPicImgFailed:(ASIHTTPRequest *)request{

}

@end
