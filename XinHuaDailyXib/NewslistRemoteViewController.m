//
//  NewslistRemoteViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewslistRemoteViewController.h"
#import "NewsArticleViewController.h"
#import "PeriodicalItem.h"
@interface NewslistRemoteViewController ()

@end

@implementation NewslistRemoteViewController

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
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 40)];
    [self.view addSubview:lab];
    lab.text = self.channel_title;
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    [bimgv addSubview:lab];
    
    
    [self.view addSubview:bimgv];

    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
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
    
      
    NSString* check = [[request URL] absoluteString];
    NSRange rag = [check rangeOfString:@"index.htm"];
    [self showWaitingView];
    if (rag.location !=NSNotFound) {
        return YES;
    }
          
    
    if(self.newslist!=nil){
        [self hideWaitingView];
        if([self.type isEqualToString:@"http"]){
            self.baseURL=[[[[request URL] absoluteString]  stringByDeletingLastPathComponent] stringByAppendingString:@"/"];
        }else{
            self.baseURL=[[self.url stringByDeletingLastPathComponent] stringByAppendingString:@"/"];
        }
        
        self.index=[self getIndexOfNewslistWith:[[request URL] lastPathComponent]];
        
        NewsArticleViewController *aController = [[NewsArticleViewController alloc] init];        
        aController.siblings=self.newslist;   
        aController.index=self.index;
        aController.type=self.type;
        aController.baseURL=self.baseURL; 
        aController.channel_title=self.channel_title;
        aController.item_title=self.channel_title;
        
        [self.navigationController pushViewController: aController animated:YES];        
        return NO;
    }
    return NO;
//    }else{
//        [self showWaitingView];
//        return NO;
//    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideWaitingView];
    NSString *currentURL = [self.webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    if([[currentURL lastPathComponent] isEqualToString:@"index.htm"]){
        NSString *urls=[self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('li').length"];
        int urls_length=[urls intValue];
        self.newslist=[[NSMutableArray alloc] initWithCapacity:urls_length];
        for(int i=0;i<urls_length;i++){
            PeriodicalItem *item=[[PeriodicalItem alloc]init];
            item.url=[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('li')[%d].firstChild.getAttribute(\"href\")",i]];
            NSString *outHTML=[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('li')[%d].parentNode.previousSibling.firstChild.innerText",i]];
            item.topic=outHTML;
            [self.newslist addObject:item];
        }
    }
}

-(int)getIndexOfNewslistWith:(NSString *)str{
    int ind=-1;
    for(int i=0;i<[self.newslist count];i++){
        if([((PeriodicalItem *)[self.newslist objectAtIndex:i]).url isEqualToString:str]){
            ind=i;
            break;
        }
    }
    return ind;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
