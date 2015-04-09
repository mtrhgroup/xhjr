//
//  ExpressViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExpressNotificationViewController.h"
#import "NewsDefine.h"
#import "ASIHTTPRequest.h"
#import "NSIks.h"
#import "NewsXmlParser.h"
#import "XinHuaAppDelegate.h"
#import "NewsDbOperator.h"
#import "NetStreamStatistics.h"
#import "ZipArchive.h"
#import "NewsZipReceivedReportTask.h"
@interface ExpressNotificationViewController ()

@end

@implementation ExpressNotificationViewController
@synthesize webView;
@synthesize waitingView;
@synthesize indicator;
@synthesize item_id;
@synthesize emptyinfo_view;

- (void)viewDidUnload
{
    [super viewDidUnload];
    [webView release];
    [waitingView release];
    [indicator release];
    [item_id release];
    [emptyinfo_view release];
    // Release any retained subviews of the main view.
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewsFromLocal) name:KReceivedPush object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [butb release];
    NSLog(@"AAAAA");
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"最新信息";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    [self.view addSubview:bimgv];
    [bimgv release];

    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    self.webView.delegate=self;
   
    [self.view addSubview:webView];
    [self makeWaitingView];
    [self makeEmptyInfo];
    [self showWaitingView];
    [self loadNewsFromWeb];

}
-(void)backAction{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)loadNewsFromLocal{

    NSLog(@"%@%d",@"loadNewsFromLocal1",item_id.intValue);
    XDailyItem* tempItem =[AppDelegate.db GetXdailyByItemId: [NSNumber numberWithInt:item_id.intValue]];
    [self NewsDownloadFileCompleted:tempItem];
}

-(void)loadNewsFromWeb{   
    XDailyItem* tempItem;
    tempItem =[AppDelegate.db GetXdailyByItemId: [NSNumber numberWithInt:item_id.intValue]];
    if(tempItem!=nil) 
    {
        [self NewsDownloadFileCompleted:tempItem];
        return;
        
    }
    
    NSString*  itemurl =  [NSString stringWithFormat:KXdailyUrlOnlyOne,self.item_id];
    NSLog(@"itemurl = %@",itemurl);
    ASIHTTPRequest* myrequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:itemurl]];
    [myrequest setShouldAttemptPersistentConnection:NO];
    [myrequest setTimeOutSeconds:30];
    myrequest.defaultResponseEncoding = NSUTF8StringEncoding;
    [myrequest setCompletionBlock:^{
        NSString *responseString = [myrequest responseString];
        NSLog(@"responseString = %@",responseString);        
        XDailyItem * xdaily = [NewsXmlParser ParseXDailyItem:responseString];
        xdaily.item_id=[NSNumber numberWithInt:self.item_id.intValue];
        [self downloadNewsExpress:xdaily];
        [myrequest release];
    }];
    
    [myrequest setFailedBlock:^{
        NSError *error = [myrequest error];
        NSLog(@"error = %@",[error localizedDescription]);
        [self hideWaitingView];
        [self showEmptyInfo];
        [myrequest release];
    }];
    [myrequest startAsynchronous];
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
        [self saveToDB:xdaily];
        [self NewsDownloadFileCompleted:xdaily];
        [zip release];
        [request release];
        
    }];
    [request setFailedBlock:^{
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
    }];
    [request setDownloadDestinationPath:filePath];
    request.userInfo=[NSDictionary dictionaryWithObjectsAndKeys:filePath,@"file_path",xdaily,@"item",nil];
    [request startAsynchronous];
    return YES;    
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
-(void)makeWaitingView{
    waitingView=[[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 460+(iPhone5?88:0))];
    waitingView.backgroundColor=[UIColor colorWithWhite:1 alpha:1];
    waitingView.hidden=true;
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 100, 32, 32)];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 150, 231, 65)];
    imageView.image=[UIImage imageNamed:@"logo.png"];
    [waitingView addSubview:imageView];
    [imageView release];
    [waitingView addSubview:indicator];
    [self.view addSubview:waitingView];
    
}
-(void)showWaitingView{
    [indicator startAnimating];
    waitingView.hidden=false;
}
-(void)hideWaitingView{
    [indicator stopAnimating];
    waitingView.hidden=true;
}
-(void)NewsDownloadFileCompleted:(XDailyItem*) item{
    NSString* path_url = [item.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];   
    NSString* url=[item.pageurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]; 
    NSString* filename=[url lastPathComponent];
    NSString* dirName = [path_url lastPathComponent];
    NSString* filePath =[[CommonMethod fileWithDocumentsPath:dirName] stringByDeletingPathExtension];    
    NSString* urlStr=[NSString stringWithFormat:@"%@/%@",[filePath stringByDeletingPathExtension],filename];  
    item.isRead  = YES;
    [AppDelegate.db ModifyDailyNews:item];
    [AppDelegate.db SaveDb];
   [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:urlStr]]];
    
}
-(void)NewsDownloadFileErrCallBack:(XDailyItem*) item{
    [self hideWaitingView];
    [self showEmptyInfo];

}
-(void)AllZipFinished{
    
    //NSLog(@"%@",@"AllZipFinished");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideWaitingView];
     [self showEmptyInfo];
}
- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self showWaitingView];
    return YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideWaitingView];
    NSString *strFontSize=[[NSUserDefaults standardUserDefaults] objectForKey:@"FONTSIZE"];
    if([strFontSize isEqualToString:@"大"]){
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'"]; 
    }else if([strFontSize isEqualToString:@"中"]){
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"]; 
    }else if([strFontSize isEqualToString:@"小"]){
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '50%'"]; 
    }
    
}
-(void)showEmptyInfo{
    self.emptyinfo_view.hidden=NO;
}
-(void)makeEmptyInfo{
    UIView *emptyView=[[UIView alloc]initWithFrame:CGRectMake(0,44,320,416+(iPhone5?88:0))];
    //    emptyView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"1.png"]];
    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 100)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = @"下载失败，可主页面手动更新，继续尝试下载。";
    labtext.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    labtext.textAlignment=UITextAlignmentCenter;
    labtext.textColor=[UIColor grayColor];
    labtext.backgroundColor = [UIColor clearColor];
    [emptyView addSubview:labtext];
    [labtext release];
    self.emptyinfo_view=emptyView;
    self.emptyinfo_view.hidden=YES;
    [self.view  addSubview:emptyView];
    [emptyView release];
}
-(void)hideEmptyInfo{
    self.emptyinfo_view.hidden=YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
