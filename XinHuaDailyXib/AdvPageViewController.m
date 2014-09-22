//
//  AdvPageViewController.m
//  XinHuaDailyXib
//
//  Created by 张健 on 14-3-7.
//
//

#import "AdvPageViewController.h"
#import "VersionInfo.h"
@interface AdvPageViewController ()

@end

@implementation AdvPageViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewDidLayoutSubviews {
    // only works for iOS 7+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        // snaps the view under the status bar (iOS 6 style)
        viewBounds.origin.y = topBarOffset*-1;
        
        // shrink the bounds of your view to compensate for the offset
        //viewBounds.size.height = viewBounds.size.height -20;
        self.view.bounds = viewBounds;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"ext_navbar.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    NSLog(@"AAAAA");
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"最新信息";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    [bimgv addSubview:lab];
    [self.view addSubview:bimgv];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    self.webView.delegate=self;    
    [self.view addSubview:webView];
    [self makeEmptyInfo];
    [self loadAdvPage];
}
-(void)loadAdvPage{
    VersionInfo *version_info_local=[self getLocalVersionInfo];
    NSString* advPath = [CommonMethod fileWithDocumentsPath:@""];
    version_info_local.advPagePath=[version_info_local.advPagePath stringByReplacingCharactersInRange:NSMakeRange(0, 72) withString:advPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:version_info_local.advPagePath]]];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showEmptyInfo];
}
- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideEmptyInfo];
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
    UIControl *emptyView=[[UIControl alloc]initWithFrame:CGRectMake(0,44,320,416+(iPhone5?88:0))];
    //    emptyView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"1.png"]];
    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 100)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = @"下载失败，点击屏幕刷新";
    labtext.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    labtext.textAlignment=NSTextAlignmentCenter;
    labtext.textColor=[UIColor grayColor];
    labtext.backgroundColor = [UIColor clearColor];
    [emptyView addSubview:labtext];
    self.emptyinfo_view=emptyView;
    self.emptyinfo_view.hidden=YES;
    [emptyView addTarget:self action:@selector(loadAdvPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:emptyView];
}
-(void)hideEmptyInfo{
    self.emptyinfo_view.hidden=YES;
}
-(VersionInfo *)getLocalVersionInfo{
    NSData *old_data=[[NSUserDefaults standardUserDefaults]objectForKey:@"version_info"];
    VersionInfo *version_info_local=[NSKeyedUnarchiver unarchiveObjectWithData:old_data];
    return version_info_local;
}
@end
