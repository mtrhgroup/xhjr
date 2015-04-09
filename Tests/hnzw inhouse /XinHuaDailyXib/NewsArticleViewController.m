//
//  NewsArticleViewController.m
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsArticleViewController.h"
#import "Toast+UIView.h"
#import "NewsFavorManager.h"
@interface NewsArticleViewController ()

@end

@implementation NewsArticleViewController
@synthesize previousWebView;
@synthesize nextWebView;
@synthesize topWebView;
@synthesize waitingView;
@synthesize waitingAlert;
@synthesize indicator;
@synthesize siblings;
@synthesize baseURL;
@synthesize type;
@synthesize index;
@synthesize channel_title;
@synthesize item_title;
@synthesize bottonBar;
UIButton * favor_yes_btn;
UIButton * favor_no_btn;
float mLastScale;
float mCurrentScale;
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colectOKHandler) name:KUpdateFavorList object:nil];
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [previousWebView release];
    [nextWebView release];
    [topWebView release];
    [waitingView release];
    [waitingAlert release];
    [indicator release];
    [siblings release];
    [baseURL release];
    [type release];
    [channel_title release];
    [item_title release];
    [bottonBar release];
    [favor_no_btn release];
    [favor_yes_btn release];
    // Release any retained subviews of the main view.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
//    UIView* booktopView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 832,640)];
//    booktopView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bigtablebg.png"]];
//    [self.view addSubview:booktopView];
//    [booktopView release];
    //UIwebView
    previousWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    nextWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    topWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    
    previousWebView.backgroundColor= [UIColor whiteColor]; 
    nextWebView.backgroundColor= [UIColor whiteColor]; 
    topWebView.backgroundColor= [UIColor whiteColor]; 


    self.topWebView.delegate=self;
    self.previousWebView.delegate=self;
    self.nextWebView.delegate=self;
    
    UIPanGestureRecognizer* panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGest setMaximumNumberOfTouches:1];
    [panGest setMinimumNumberOfTouches:1];
    [topWebView addGestureRecognizer:panGest];
    [panGest release];
    
    
    UIPanGestureRecognizer* panGest1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGest1 setMaximumNumberOfTouches:1];
    [panGest1 setMinimumNumberOfTouches:1];
    [previousWebView addGestureRecognizer:panGest1];
    [panGest1 release];
    
    UIPanGestureRecognizer* panGest2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGest2 setMaximumNumberOfTouches:1];
    [panGest2 setMinimumNumberOfTouches:1];
    [nextWebView addGestureRecognizer:panGest2];
    [panGest2 release];
    
    [self.view addSubview:previousWebView];
    [self.view addSubview:nextWebView];
    [self.view addSubview:topWebView];
    
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [butb release];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 40)];
    [self.view addSubview:lab];
    lab.text = self.item_title;
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
    [self makeWaitingView];
    [self makeWaitingAlert];
    [[self.view.subviews objectAtIndex:3] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_current_news]]]];
    [[self.view.subviews objectAtIndex:1] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_previous_news]]]];
    [[self.view.subviews objectAtIndex:2] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_next_news]]]]; 
    
    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, 40,40)]; 
    UIImage *favor_image=[UIImage imageNamed:@"clip.png"];
    [favorBtn setImage:favor_image forState:UIControlStateNormal];
    [self.view addSubview:favorBtn];
    [favorBtn release];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint v =[recognizer velocityInView:recognizer.view];
    if(recognizer.state==UIGestureRecognizerStateEnded){
        if(v.x>0&&abs(translation.x)>abs(translation.y)){
            [self swipeRightAction:nil];
        }else if(v.x<0&&abs(translation.x)>abs(translation.y)){
            [self swipeLeftAction:nil];
            
        }
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
}

-(void)makeBottonBar{
    self.bottonBar = [[[UIView alloc] initWithFrame:CGRectMake(0, 373+44, 320, 44)] autorelease];
    self.bottonBar.hidden=YES;
    self.bottonBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottombg.png"]]; 
    [self.view addSubview:self.bottonBar];
}
-(void)showBottonBar{
    self.bottonBar.hidden=NO;
}
-(void)hideBottonBar{
    self.bottonBar.hidden=YES;
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeWaitingAlert{
  //  [self.view makeToastActivity:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];   
}
-(void)showWaitingAlert{
    //[self.waitingAlert show];
    [self.view makeToastActivity:[NSValue valueWithCGPoint:CGPointMake(160, 220)]];     
}
-(void)hideWaitingAlert{
    [self.view hideToastActivity];
}
-(void)makeWaitingView{
    waitingView=[[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 390)];
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
-(NSURL *)makeURLwith:(NSString *)str{
    if([self.type isEqualToString:@"file"]){
        NSLog(@"article url %@",[self.baseURL stringByAppendingString:str]);
      return  [NSURL fileURLWithPath:[self.baseURL stringByAppendingString:str]];
        
    }else if([self.type isEqualToString:@"http"]){       
      return  [NSURL URLWithString:[self.baseURL stringByAppendingString:str]];  
    }
    return nil;
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

-(NSString *)executeJS:(NSString *)cmdStr{
    return [[self.view.subviews objectAtIndex:3] stringByEvaluatingJavaScriptFromString:cmdStr];
}
-(void)colectOKHandler{
    if([[NewsFavorManager sharedInstance] iscollected:[self.view.subviews objectAtIndex:3]]){
        [self setFavorBtnStatus:YES];
    }else {
        [self setFavorBtnStatus:NO];
    }
    [self hideWaitingAlert];
}
- (void)colect:(id)sender {
    if([[NewsFavorManager sharedInstance] iscollected:[self.view.subviews objectAtIndex:3]]){
       [[NewsFavorManager sharedInstance] removeArticle:[self.view.subviews objectAtIndex:3]];
       [self setFavorBtnStatus:false];
    }else {
      [self showWaitingAlert];
      [self performSelector:@selector(saveArticle) withObject:nil afterDelay:0.2];
    } 

}
-(void)saveArticle{
    [[NewsFavorManager sharedInstance] saveArticle:[self.view.subviews objectAtIndex:3]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [previousWebView release];
    [nextWebView release];
    [topWebView release];
    [super dealloc];
}
- (void)swipeLeftAction:(id)sender {
    NSLog(@"%@",@"swipeLeftAction");
    NSLog(@"%@",[[self.view.subviews objectAtIndex:3] stringByEvaluatingJavaScriptFromString:@"document.title"]);
    CATransition *animation = [CATransition animation];
    //animation.delegate = self;
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	animation.type = kCATransitionReveal;
	animation.subtype = kCATransitionFromRight;	
	[self.view.layer addAnimation:animation forKey:@"animation"];
	[self.view exchangeSubviewAtIndex:3 withSubviewAtIndex:2];
	[UIView commitAnimations];
    if([[NewsFavorManager sharedInstance] iscollected:[self.view.subviews objectAtIndex:3]]){
        [self setFavorBtnStatus:true];
    }else {
        [self setFavorBtnStatus:false];
    }  
    [self moveDownIndex];
    [[self.view.subviews objectAtIndex:1] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_previous_news]]]];
    [[self.view.subviews objectAtIndex:2] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_next_news]]]];
    NSLog(@"after_views__-%@",[self.view subviews]);
}

- (void)swipeRightAction:(id)sender {
    NSLog(@"%@",@"swipeRightAction");
    CATransition *animation = [CATransition animation];
    //animation.delegate = self;
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	animation.type = kCATransitionMoveIn;
	animation.subtype = kCATransitionFromLeft;	
	[self.view.layer addAnimation:animation forKey:@"animation"];
    [self.view exchangeSubviewAtIndex:3 withSubviewAtIndex:1];
    [UIView commitAnimations];
    if([[NewsFavorManager sharedInstance] iscollected:[self.view.subviews objectAtIndex:3]]){
        [self setFavorBtnStatus:true];
    }else {
        [self setFavorBtnStatus:false];
    }  
    [self moveUpIndex];
    [[self.view.subviews objectAtIndex:1] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_previous_news]]]];
    [[self.view.subviews objectAtIndex:2] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_next_news]]]];
    
}
-(int)moveDownIndex{
    if(self.index==[self.siblings count]-1){
        index=0;
    }else{
        index++;
    }
    return index;
}
-(int)moveUpIndex{
    if(self.index==0){
        index=[self.siblings count]-1;
    }else{
        index--;
    }
    return index;
}
-(NSString *)get_current_news{
    return [self.siblings objectAtIndex:index];
}
-(NSString *)get_previous_news{
            if(index==0){
                return [self.siblings objectAtIndex:[self.siblings count]-1]; 
            }
            else{
                return [self.siblings objectAtIndex:index-1]; 
            }
    return nil;
}
-(NSString *)get_next_news{
     if(index==[self.siblings count]-1)return [self.siblings objectAtIndex:0];
       else return [self.siblings objectAtIndex:index+1];
    return nil;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   [self hideWaitingView];
}
- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self showWaitingView];
    return  YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideWaitingView];
    if([[NewsFavorManager sharedInstance] iscollected:[self.view.subviews objectAtIndex:3]]){
        [self setFavorBtnStatus:true];
    }else {
        [self setFavorBtnStatus:false];
    } 
    NSString *strFontSize=[[NSUserDefaults standardUserDefaults] objectForKey:@"FONTSIZE"];
    if([strFontSize isEqualToString:@"大"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'"]; 
    }else if([strFontSize isEqualToString:@"中"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"]; 
    }else if([strFontSize isEqualToString:@"小"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '50%'"]; 
    }
    
}

-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
 {
     NSLog(@"%@",@"handleSingleFingerEvent");
     if(self.bottonBar.hidden==YES){
         [self showBottonBar];
     }else{
         [self hideBottonBar];
     }
 }

@end
