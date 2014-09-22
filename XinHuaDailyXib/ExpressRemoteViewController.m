//
//  ExpressRemoteViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExpressRemoteViewController.h"
#import "NewsFavorManager.h"
#import "FeedBackToAuthorViewController.h"

@interface ExpressRemoteViewController ()

@end

@implementation ExpressRemoteViewController

@synthesize webView;
@synthesize waitingView;
@synthesize indicator;
@synthesize url;
@synthesize type;
@synthesize newslist;
@synthesize baseURL;
@synthesize index;
@synthesize channel_title;
@synthesize channel_id;
UIButton * favor_yes_btn;
UIButton * favor_no_btn;
UIButton * menu_btn;
UIControl * trs_ctrl;
float mLastScale;
float mCurrentScale;
BOOL fontLarger;

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
    fontLarger=NO;
    self.navigationController.navigationBar.hidden = YES;
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"ext_navbar.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    NSLog(@"AAAAA");
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = self.channel_title;
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    [bimgv addSubview:lab];
    
    menu_btn = [[UIButton alloc] initWithFrame:CGRectMake(276, 5, 35,35)];
    UIImage *menu_image=[UIImage imageNamed:@"ext_nav_columns.png"];
    [menu_btn setImage:menu_image forState:UIControlStateNormal];
    [menu_btn  addTarget:self action:@selector(toggleMenuBar) forControlEvents:UIControlEventTouchUpInside];
    [bimgv addSubview:menu_btn];
    
    [self.view addSubview:bimgv];

    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    self.webView.delegate=self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[self makeURL]]];
    [self.view addSubview:webView];
    for (UIView* sv in [self.webView subviews])        
    {
        NSLog(@"first layer: %@", sv);        
        for (UIView* s2 in [sv subviews])            
        {            
            NSLog(@"second layer: %@ *** %@", s2, [s2 class]);            
            for (UIGestureRecognizer *recognizer in s2.gestureRecognizers) {
                if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]){                    
                    recognizer.enabled = NO;                    
                }                
            }
        }        
    }
    [self makeWaitingView];
    [self makeMenuBar];
}



-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES]; 
}
-(NSURL *)makeURL{    
    if([self.type isEqualToString:@"file"]){
        return  [NSURL fileURLWithPath:self.url];
    }else if([self.type isEqualToString:@"http"]){
        return  [NSURL URLWithString:self.url];  
    }
    return nil;
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
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    //    [alterview show];
    [self hideWaitingView];
}
- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self showWaitingView];
    return YES;    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideWaitingView];
    if([[NewsFavorManager sharedInstance] iscollected:self.webView]){
        [self setFavorBtnStatus:true];
    }else {
        [self setFavorBtnStatus:false];
    }  

}

-(int)getIndexOfNewslistWith:(NSString *)str{
    int ind=-1;
    for(int i=0;i<[self.newslist count];i++){
        if([[self.newslist objectAtIndex:i] isEqualToString:str]){
            ind=i;
            break;
        }
    }
    return ind;
}


-(void)setFavorBtnStatus:(bool)collected{
    if(collected){
        favor_yes_btn.hidden=NO;
        favor_no_btn.hidden=YES;
    }else{
        favor_yes_btn.hidden=YES;
        favor_no_btn.hidden=NO;  
    }                    
}

- (IBAction)colect:(id)sender {
    NSLog(@"colect...colect");
    //当点击收藏的时候保存   
    if([[NewsFavorManager sharedInstance] iscollected:self.webView]){
        [[NewsFavorManager sharedInstance] removeArticle:self.webView];
        [self setFavorBtnStatus:false];
    }else {
        [[NewsFavorManager sharedInstance] saveArticle:self.webView];
        [self setFavorBtnStatus:true];
    }      
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)makeMenuBar{
    
    trs_ctrl = [[UIControl alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    [trs_ctrl  addTarget:self action:@selector(hideMenuBar) forControlEvents:UIControlEventTouchUpInside];
    trs_ctrl.hidden=YES;
    [self.view addSubview:trs_ctrl];
    
    
    self.bottonBar = [[UIView alloc] initWithFrame:CGRectMake(205, 34, 114, 185)];
    self.bottonBar.hidden=YES;
    self.bottonBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popbg.png"]];
    [self.view addSubview:self.bottonBar];
    
    favor_no_btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, 150,40)];
    [favor_no_btn  addTarget:self action:@selector(colect:) forControlEvents:UIControlEventTouchUpInside];
    favor_no_btn.hidden=YES;
    UIImageView *favor_no_pic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favor_pic.png"]];
    favor_no_pic.frame=CGRectMake(0, 13, 18, 17);
    [favor_no_btn addSubview:favor_no_pic];
    UIImageView *favor_no_text=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favor_txt.png"]];
    favor_no_text.frame=CGRectMake(40, 15, 28, 14);
    [favor_no_btn addSubview:favor_no_text];
    favor_no_btn.showsTouchWhenHighlighted=YES;
    [self.bottonBar addSubview:favor_no_btn];
    
    
    
    favor_yes_btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, 150,40)];
    [favor_yes_btn  addTarget:self action:@selector(colect:) forControlEvents:UIControlEventTouchUpInside];
    favor_yes_btn.hidden=YES;
    UIImageView *favor_yes_pic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favor_yes_pic.png"]];
    favor_yes_pic.frame=CGRectMake(0, 13, 18, 17);
    [favor_yes_btn addSubview:favor_yes_pic];
    UIImageView *favor_yes_text=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favor_txt.png"]];
    favor_yes_text.frame=CGRectMake(40, 15, 28, 14);
    [favor_yes_btn addSubview:favor_yes_text];
    favor_yes_btn.showsTouchWhenHighlighted=YES;
    [self.bottonBar addSubview:favor_yes_btn];
    
    UIImageView *segline=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segline.png"]];
    segline.frame=CGRectMake(5, 48, 103, 0.5);
    [self.bottonBar addSubview:segline];
    
    UIButton* shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 49, 150,40)];
    [shareBtn  addTarget:self action:@selector(showSMSPicker) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *share_pic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_pic.png"]];
    share_pic.frame=CGRectMake(0, 13, 19, 16);
    [shareBtn addSubview:share_pic];
    UIImageView *share_txt=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_txt.png"]];
    share_txt.frame=CGRectMake(40, 15, 28, 14);
    [shareBtn addSubview:share_txt];
    shareBtn.showsTouchWhenHighlighted=YES;
    [self.bottonBar addSubview:shareBtn];
    
    UIImageView *segline2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segline.png"]];
    segline2.frame=CGRectMake(5, 89, 103, 0.5);
    [self.bottonBar addSubview:segline2];
    
    UIButton* opinionBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 90, 150,40)];
    [opinionBtn  addTarget:self action:@selector(navToFeedback) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *opinion_pic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"opinion_pic.png"]];
    opinion_pic.frame=CGRectMake(0, 13, 20, 15);
    [opinionBtn addSubview:opinion_pic];
    UIImageView *opinion_txt=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"opinion_txt.png"]];
    opinion_txt.frame=CGRectMake(28, 15, 56, 14);
    [opinionBtn addSubview:opinion_txt];
    opinionBtn.showsTouchWhenHighlighted=YES;
    [self.bottonBar addSubview:opinionBtn];
    
    UIImageView *segline3=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segline.png"]];
    segline3.frame=CGRectMake(5, 130, 103, 0.5);
    [self.bottonBar addSubview:segline3];
    
    UIButton* fontBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 130, 150,40)];
    [fontBtn  addTarget:self action:@selector(toggleFont) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *font_pic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"font_pic.png"]];
    font_pic.frame=CGRectMake(0, 13, 25, 17);
    [fontBtn addSubview:font_pic];
    UIImageView *font_txt=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"font_txt.png"]];
    font_txt.frame=CGRectMake(28, 15, 56, 14);
    [fontBtn addSubview:font_txt];
    fontBtn.showsTouchWhenHighlighted=YES;
    [self.bottonBar addSubview:fontBtn];
}
-(void)toggleFont{
    [self hideMenuBar];
    if(fontLarger){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
        fontLarger=NO;
    }else{
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'"];
        fontLarger=YES;
    }
}
-(void)navToFeedback{
    [self hideMenuBar];
    NSString* articleid=[self.url substringWithRange:NSMakeRange([self.url  length]-11, 7)];
    NSLog(@"%@",articleid);
    FeedBackToAuthorViewController* nbx = [[FeedBackToAuthorViewController alloc] init];
    nbx.articleId=articleid;
    UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:nbx];
    nbx.mode=0;
    [self presentViewController:unc animated:YES completion:nil];
}
-(void)toggleMenuBar{
    
    if(self.bottonBar.hidden){
        [self showMenuBar];
    }else{
        [self hideMenuBar];
    }
}
-(void)showMenuBar{
    trs_ctrl.hidden=NO;
    self.bottonBar.hidden=NO;
}
-(void)hideMenuBar{
    trs_ctrl.hidden=YES;
    self.bottonBar.hidden=YES;
}
-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    NSLog(@"%@",@"handleSingleFingerEvent");
    if(self.bottonBar.hidden==YES){
        [self showMenuBar];
    }else{
        [self hideMenuBar];
    }
}
-(void)showSMSPicker{
    [self hideMenuBar];
    //  The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.
    //  So, we must verify the existence of the above class and log an error message for devices
    //      running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support
    //      MFMessageComposeViewController API.
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"设备没有短信功能" message:nil delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate=self;
            [alert show];
        }
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" message:nil delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate=self;
        [alert show];
    }
}
-(void)displaySMSComposerSheet
{
    NSString *shareStr=[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].innerHTML"];
    NSLog(@"share in %@",shareStr);
    shareStr=[self htmlclear:shareStr];
    NSLog(@"share out %@",shareStr);
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.body=shareStr;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: SMS sent failed");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"短信发送失败！" message:nil delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate=self;
            [alert show];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSString *)htmlclear:(NSString *)htmlStr{
    NSMutableString *outputStr=[NSMutableString stringWithString:htmlStr];
    [outputStr replaceOccurrencesOfString:@"<script.*</script>" withString:@"" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"<style.*</style>" withString:@"" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"'" withString:@"''" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"</div>" withString:@"\n" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"<p><p><p>" withString:@"\n" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"<p><p>" withString:@"\n" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"<p>" withString:@"\n" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"<(/?p|br[^>]*)>" withString:@"" options:NSRegularExpressionSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"<[^<>]+>" withString:@" " options:NSRegularExpressionSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"\\[--([^-]+)--\\]" withString:@"<$1>" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"&ldquo;" withString:@"\"" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"&rdquo;" withString:@"\"" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"&middot;" withString:@"." options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"\n\n\n\n\n" withString:@"\n" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"\n\n\n\n" withString:@"\n" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"\n\n\n" withString:@"\n" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    [outputStr replaceOccurrencesOfString:@"\n\n" withString:@"\n" options:NSLiteralSearch  range:NSMakeRange(0, [outputStr length])];
    return outputStr;
}

@end
