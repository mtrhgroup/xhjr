//
//  ExpressRemoteViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExpressRemoteViewController.h"
#import "NewsArticleViewController.h"
#import "NewsFavorManager.h"
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    [webView release];
    [waitingView release];
    [indicator release];
    [url release];
    [type release];
    [newslist release];
    [baseURL release];
    [channel_title release];
    [channel_id release];
    [favor_no_btn release];
    [favor_yes_btn release];
    // Release any retained subviews of the main view.
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
    [butb addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [butb release];
    NSLog(@"AAAAA");
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = self.channel_title;
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    
    favor_no_btn = [[UIButton alloc] initWithFrame:CGRectMake(276, 5, 33,33)];     
    UIImage *favor_no_image=[UIImage imageNamed:@"favor_pressed.png"];
    [favor_no_btn setImage:favor_no_image forState:UIControlStateNormal];
    [favor_no_btn  addTarget:self action:@selector(colect:) forControlEvents:UIControlEventTouchUpInside];
    favor_no_btn.hidden=YES;
    [bimgv addSubview:favor_no_btn];
    
    favor_yes_btn = [[UIButton alloc] initWithFrame:CGRectMake(276, 5, 33,33)];     
    UIImage *favor_yes_image=[UIImage imageNamed:@"favor_normal.png"];
    [favor_yes_btn setImage:favor_yes_image forState:UIControlStateNormal];
    [favor_yes_btn  addTarget:self action:@selector(colect:) forControlEvents:UIControlEventTouchUpInside];
    favor_yes_btn.hidden=YES;
    [bimgv addSubview:favor_yes_btn];
    
    [self.view addSubview:bimgv];
    [bimgv release];

    
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

- (void)dealloc {
    [webView release];
    [super dealloc];
}
@end
