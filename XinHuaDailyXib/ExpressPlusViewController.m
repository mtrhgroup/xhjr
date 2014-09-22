//
//  ExpressPlusViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExpressPlusViewController.h"
#import "XDailyItem.h"
#import "XinHuaAppDelegate.h"
#import "NewsDbOperator.h"
#import "NewsFavorManager.h"
#import "FeedBackToAuthorViewController.h"
#import "UserActions.h"
#import <ShareSDK/ShareSDK.h>
@interface ExpressPlusViewController ()

@end

@implementation ExpressPlusViewController
@synthesize previousWebView;
@synthesize nextWebView;
@synthesize topWebView;
@synthesize waitingView;
@synthesize indicator;
@synthesize siblings;
@synthesize baseURL;
@synthesize type;
@synthesize index;
@synthesize channel_title;
@synthesize newslist;
@synthesize bottonBar;
UIButton * favor_yes_btn;
UIButton * favor_no_btn;
UIButton * menu_btn;
UIControl * trs_ctrl;
float mLastScale;
float mCurrentScale;
BOOL fontLarger;
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleDisplayMode) name:KDisplayMode object:nil];
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
-(void)toggleDisplayMode{
    NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
    if(displayMode==nil||[displayMode isEqualToString:@"日间模式"]){
        [self toggleToDayMode];
    }else{
        [self toggleToNightMode];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    fontLarger=NO;
    self.navigationController.navigationBar.hidden = YES;
    UIView* booktopView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 832,640+(iPhone5?88:0))];
    booktopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:booktopView];
    
    //UIwebView
    previousWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    nextWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    topWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    

    
    for (UIView* sv in [self.previousWebView subviews])        
    {      
        for (UIView* s2 in [sv subviews])            
        {                      
            for (UIGestureRecognizer *recognizer in s2.gestureRecognizers) {
                if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]){                    
                    recognizer.enabled = NO;                    
                }                
            }
        }        
    }
    for (UIView* sv in [self.nextWebView subviews])        
    {       
        for (UIView* s2 in [sv subviews])            
        {                      
            for (UIGestureRecognizer *recognizer in s2.gestureRecognizers) {
                if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]){                    
                    recognizer.enabled = NO;                    
                }                
            }
        }        
    }
    for (UIView* sv in [self.topWebView subviews])        
    {    
        for (UIView* s2 in [sv subviews])            
        {                       
            for (UIGestureRecognizer *recognizer in s2.gestureRecognizers) {
                if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]){                    
                    recognizer.enabled = NO;                    
                }                
            }
        }        
    }
    self.topWebView.delegate=self;
    self.previousWebView.delegate=self;
    self.nextWebView.delegate=self;
    
    UIPanGestureRecognizer* panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGest setMaximumNumberOfTouches:1];
    [panGest setMinimumNumberOfTouches:1];
    [topWebView addGestureRecognizer:panGest];
    
    
    UIPanGestureRecognizer* panGest1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGest1 setMaximumNumberOfTouches:1];
    [panGest1 setMinimumNumberOfTouches:1];
    [previousWebView addGestureRecognizer:panGest1];
    
    UIPanGestureRecognizer* panGest2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGest2 setMaximumNumberOfTouches:1];
    [panGest2 setMinimumNumberOfTouches:1];
    [nextWebView addGestureRecognizer:panGest2];
    
    [self.view addSubview:previousWebView];
    [self.view addSubview:nextWebView];
    [self.view addSubview:topWebView];

    
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"ext_navbar.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    
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
    [self makeWaitingView];
    NSLog(@"subview___%@",self.view.subviews);
    [[self.view.subviews objectAtIndex:3] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_current_news]]]];
    [[self.view.subviews objectAtIndex:1] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_previous_news]]]];
    [[self.view.subviews objectAtIndex:2] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_next_news]]]]; 
    
    
    //判断是否收藏过
    if([[NewsFavorManager sharedInstance] iscollected:[self.view.subviews objectAtIndex:3]]){
            [self setFavorBtnStatus:true];
        }else{
            [self setFavorBtnStatus:false];
        }  
    
    
    //初始化收藏夹
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];  
    NSString *filename=[path stringByAppendingPathComponent:@"fav.plist"];   //获取路径
    NSFileManager* fm = [NSFileManager defaultManager];   
    if ( [fm fileExistsAtPath:filename] == NO) {
        [fm createFileAtPath:filename contents:nil attributes:nil];  //创建一个plist文件
        NSLog(@"create file !");
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory
                                                        object: self];
    
    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, 40,40)]; 
    UIImage *favor_image=[UIImage imageNamed:@"clip.png"];
    [favorBtn setImage:favor_image forState:UIControlStateNormal];
    [self.view addSubview:favorBtn];
    [self makeMenuBar];
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateInbox
                                                        object: self];
    [self toggleDisplayMode];
    [self setItemHasRead];

	// Do any additional setup after loading the view.
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
-(void)toggleToDayMode{
    self.view.backgroundColor=[UIColor whiteColor];
    previousWebView.backgroundColor= [UIColor whiteColor];
    nextWebView.backgroundColor= [UIColor whiteColor];
    topWebView.backgroundColor= [UIColor whiteColor];
    waitingView.backgroundColor=[UIColor whiteColor];
    
}
-(void)toggleToNightMode{
//    self.view.backgroundColor=[UIColor blackColor];
//    previousWebView.backgroundColor= [UIColor blackColor];
//    previousWebView.opaque=NO;
//    nextWebView.backgroundColor= [UIColor blackColor];
//    nextWebView.opaque=NO;
//    topWebView.backgroundColor= [UIColor blackColor];
//    topWebView.opaque=NO;
//    waitingView.backgroundColor=[UIColor blackColor];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeWaitingView{
    waitingView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 420+(iPhone5?88:0))];
    waitingView.backgroundColor=[UIColor clearColor];
    waitingView.hidden=true;
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 100, 32, 32)];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 150, 231, 65)];
    imageView.image=[UIImage imageNamed:@"logo1.png"];
    imageView.backgroundColor=[UIColor clearColor];
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
-(NSURL *)makeURLwith:(XDailyItem *)item{
    NSString* path_url = [item.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];   
    NSString* url=[item.pageurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]; 
    NSString* filename=[url lastPathComponent];
    NSString* dirName = [path_url lastPathComponent];
    NSString* filePath =[[CommonMethod fileWithDocumentsPath:dirName] stringByDeletingPathExtension];
    NSString* urlStr=[NSString stringWithFormat:@"%@/%@",[filePath stringByDeletingPathExtension],filename];  
    if([self.type isEqualToString:@"file"]){
        return  [NSURL fileURLWithPath:[self.baseURL stringByAppendingString:urlStr]];
    }else if([self.type isEqualToString:@"http"]){       
        return  [NSURL URLWithString:[self.baseURL stringByAppendingString:urlStr]];  
    }
    return nil;
}
//-(NSString *)getPathURL{
//    XDailyItem *item=[self get_current_news];
//    NSString* path_url = [item.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];   
//    NSString* dirName = [path_url lastPathComponent];
//    NSString* filePath =[[[CommonMethod fileWithDocumentsPath:dirName] stringByDeletingPathExtension] stringByAppendingString:@"/"];
//    return filePath;
//}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)swipeLeftAction:(id)sender {
    fontLarger=NO;
    NSLog(@"%@",@"swipeLeftAction");
    NSLog(@"%@",[[self.view.subviews objectAtIndex:2] stringByEvaluatingJavaScriptFromString:@"document.title"]);
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
    }else{
        [self setFavorBtnStatus:false];
    }  
    [self moveDownIndex];
    [self setItemHasRead];
    [[self.view.subviews objectAtIndex:1] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_previous_news]]]];
    [[self.view.subviews objectAtIndex:2] loadRequest:[NSURLRequest requestWithURL:[self makeURLwith:[self get_next_news]]]];
}
-(void)setItemHasRead{
    XDailyItem *item=[self get_current_news];
    NSLog(@"#####%@",item.localPath);
    NSString *article_id=[[item.localPath lastPathComponent] substringWithRange:NSMakeRange(0, 7)];
    NSLog(@"$$$$$%@",article_id);
    [[UserActions sharedInstance] enqueueAReadAction:[NSString stringWithFormat:@"%@",article_id]];
    if(!item.isRead){
        item.isRead  = YES;
        [AppDelegate.db ModifyDailyNews:item];
        [AppDelegate.db SaveDb];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory
                                                            object: self];
    }

}

- (void)swipeRightAction:(id)sender {
    fontLarger=NO;
    NSLog(@"%@",@"swipeRightAction");
    NSLog(@"%@",[[self.view.subviews objectAtIndex:2] stringByEvaluatingJavaScriptFromString:@"document.title"]);
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
    }else{
        [self setFavorBtnStatus:false];
    }  
    [self moveUpIndex];
    [self setItemHasRead];
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
-(XDailyItem *)get_current_news{
    return [self.siblings objectAtIndex:index];
}
-(XDailyItem *)get_previous_news{
    if(index==0){
        return [self.siblings objectAtIndex:[self.siblings count]-1]; 
    }
    else{
        return [self.siblings objectAtIndex:index-1]; 
    }
    return nil;
}
-(XDailyItem *)get_next_news{
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
    if([[NewsFavorManager sharedInstance] iscollected:webView]){
        [self setFavorBtnStatus:true];
    }else{
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
    NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
    if(displayMode==nil||[displayMode isEqualToString:@"日间模式"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].cssRules[0].style.background='#FFFFFF'"];
        [webView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].cssRules[0].style.color='#000000'"];
        [webView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].cssRules[39].style.color='#000000'"];
        [webView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].cssRules[7].style.color='#000000'"];
    }else{
//        [webView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].cssRules[0].style.background='#1E1F20'"];
//        [webView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].cssRules[0].style.color='#888888'"];
//        [webView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].cssRules[39].style.color='#888888'"];
//        [webView stringByEvaluatingJavaScriptFromString:@"document.styleSheets[0].cssRules[7].style.color='#888888'"];
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

- (void)colect:(id)sender {
    NSLog(@"colect...colect");
    //当点击收藏的时候保存   
    if([[NewsFavorManager sharedInstance] iscollected:[self.view.subviews objectAtIndex:3]]){
        [[NewsFavorManager sharedInstance] removeArticle:[self.view.subviews objectAtIndex:3]];
        [self setFavorBtnStatus:false];
    }else {
        [[NewsFavorManager sharedInstance] saveArticle:[self.view.subviews objectAtIndex:3]];
        [self setFavorBtnStatus:true];
    }      
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
    UIWebView *webView=[self.view.subviews objectAtIndex:3];
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
    XDailyItem *item=[self get_current_news];
    NSString* articleid=[item.localPath substringWithRange:NSMakeRange([item.localPath length]-11, 7)];
    NSLog(@"fee ...%@ %@",item.localPath,articleid);
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
    [self share];
}
-(void)share{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x"  ofType:@"png"];
    NSString *titleText=((XDailyItem *)[self get_current_news]).title;
    NSString *pageurl=((XDailyItem *)[self get_current_news]).pageurl;
    NSString *uri=[pageurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString *redirect_url=[NSString stringWithFormat:@"http://mis.xinhuanet.com/SXTV2/mobile%@",uri];
    NSLog(@"%@",redirect_url);
    NSString *shareStr=[NSString stringWithFormat:@"%@\n%@",titleText,redirect_url];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareStr
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:titleText
                                                  url:redirect_url
                                          description:titleText
                                            mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
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
