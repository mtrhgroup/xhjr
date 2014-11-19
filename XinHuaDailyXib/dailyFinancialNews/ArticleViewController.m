#import "ArticleViewController.h"
#import "NavigationController.h"
#import "UIWindow+YzdHUD.h"
#import "RefreshTouchView.h"
#import "AMBlurView.h"
#import "FeedBackViewController.h"
#import "CommentsViewController.h"
@interface ArticleViewController (){
    Article *_article;
    Service *_service;
    NSString *_pushArticleID;
    NSArray *fonts;
    int offset;
}
@property WebViewJavascriptBridge* bridge;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)WaitingView *waitingView;
@property(nonatomic,strong)RefreshTouchView *touchView;
@property(nonatomic,strong)PopupMenuView *popupMenuView;
@property(nonatomic,strong)ZSYPopoverListView *fontAlertView;
@property(nonatomic,strong)UIButton *comment_btn;
@property(nonatomic,strong)UILabel *comment_number_label;
@property(nonatomic,strong)UIButton *collect_btn;
@property(nonatomic,assign)BOOL isAD;
@property(nonatomic,strong)Article *ad_article;
@property (nonatomic,strong)AMBlurView *bottom_view;
@end

@implementation ArticleViewController
@synthesize waitingView=_waitingView;
@synthesize popupMenuView=_popupMenuView;
@synthesize fontAlertView=_fontAlertView;
@synthesize isAD=_isAD;
@synthesize comment_btn=_comment_btn;
@synthesize comment_number_label=_comment_number_label;
@synthesize collect_btn=_collect_btn;
@synthesize bridge=_bridge;
@synthesize ad_article=_ad_article;
- (id)initWithAritcle:(Article *)article
{
    self = [super init];
    if (self) {
        _service=AppDelegate.service;
        _article=article;
        _isAD=NO;
        fonts=[NSArray arrayWithObjects:@"特大",@"较大",@"正常",@"较小",nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStarted:) name:@"UIMovieViewPlaybackStateDidChangeNotification" object:nil];// 播放器即将播放通知
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoFinished:) name:@"UIMoviePlayerControllerWillExitFullscreenNotification" object:nil];// 播放器即将退出通知
        if(lessiOS7){
            offset=44;
        }else{
            offset=0;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFullScreen:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    }
    return self;
}
- (void)videoStarted:(NSNotification *)notification {// 开始播放
    
    
    
    
}



- (void)videoFinished:(NSNotification *)notification {//完成播放
    
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val =UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
    
    // NSLog(@"videoFinished %@", self.view.window.rootViewController.view);
    
    //
    
    // NSLog(@"a == %f", self.view.window.rootViewController.view.transform.a);
    
    // NSLog(@"b == %f", self.view.window.rootViewController.view.transform.b);
    
    // NSLog(@"c == %f", self.view.window.rootViewController.view.transform.c);
    
    // NSLog(@"d == %f", self.view.window.rootViewController.view.transform.d);
    
    // if (self.view.window.rootViewController.view.transform.c == 1 || self.view.window.rootViewController.view.transform.c == -1 ) {
    
    // CGAffineTransform transform;
    
    // //设置旋转度数
    
    // // transform = CGAffineTransformRotate(self.view.window.rootViewController.view.transform, M_PI / 2);
    
    // transform = CGAffineTransformIdentity;
    
    // [UIView beginAnimations:@"rotate" context:nil ];
    
    // [UIView setAnimationDuration:0.1];
    
    // [UIView setAnimationDelegate:self];
    
    // [self.view.window.rootViewController.view setTransform:transform];
    
    // [UIView commitAnimations];
    
    //
    
    // self.view.window.rootViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height );
    
    // }
    
    //
    
    // [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    
}
-(id)initWithPushArticleID:(NSString *)articleID{
    self = [super init];
    if (self) {
        _service=AppDelegate.service;
        _pushArticleID=articleID;
        _isAD=NO;
        fonts=[NSArray arrayWithObjects:@"特大",@"较大",@"正常",@"较小",nil];
        
        if(lessiOS7){
            offset=44;
        }else{
            offset=0;
        }
    }
    return self;
}
-(void)touchViewClicked{
    [self loadArticleContentFromNet];
}
-(void)viewWillAppear:(BOOL)animated{
    _comment_number_label.text=[NSString stringWithFormat:@"%d",_article.comments_number.intValue];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.webView setAllowsInlineMediaPlayback:YES];
    self.webView.delegate=self;
    self.webView.allowsInlineMediaPlayback=YES;
    [self.view addSubview:self.webView];
    [self initBridge];
    self.waitingView=[[WaitingView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.waitingView];
    self.touchView=[[RefreshTouchView alloc]initWithFrame:self.view.bounds];
    self.touchView.delegate=self;
    [self.view addSubview:self.touchView];
    [_service markArticleReadWithArticle:_article];
    _ad_article=[_service fetchADArticleFromDB];
    if(_article==nil){
        [self loadPushArticleFromNet];
    }else{
        if(!_article.is_cached){
            [self.waitingView show];
            [self loadArticleContentFromNet];
        }else{
            NSLog(@"%@",_article.page_path);
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_article.page_path]]];
            
        }
    }
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.fontAlertView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 240)];
    self.fontAlertView.titleName.text = @"选择字体大小";
    self.fontAlertView.web_delegate=self;
    [self.fontAlertView setSelectedFontSize:AppDelegate.user_defaults.font_size];
    if(!self.isAD){
        UIButton *like_btn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,68,34)];
        _comment_number_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 48, 34)];
        _comment_number_label.text=[NSString stringWithFormat:@"%d",_article.like_number.intValue];
        _comment_number_label.textAlignment=NSTextAlignmentRight;
        _comment_number_label.textColor=[UIColor redColor];
        _comment_number_label.backgroundColor=[UIColor clearColor];
        _comment_number_label.font = [UIFont fontWithName:@"Arial" size:24];
        [like_btn addSubview:_comment_number_label];
        UIImageView *icon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_review_default.png"]];
        icon.frame=CGRectMake(48,5,20,20);
        [like_btn addSubview:icon];
        [like_btn addTarget:self action:@selector(showComments) forControlEvents:UIControlEventTouchUpInside];
        
        
        if(_article.is_like){
            _comment_btn.enabled=NO;
            [_comment_btn setBackgroundImage:[UIImage imageNamed:@"like_on.png"] forState:UIControlStateNormal];
        }
        UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        if(lessiOS7){
            negativeSpacer.width=0;
        }else{
            negativeSpacer.width=-10;
        }
        UIBarButtonItem *like_btn_item=[[UIBarButtonItem alloc] initWithCustomView:like_btn];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,like_btn_item,nil] animated:YES];
        
        self.bottom_view=[AMBlurView new];
        self.bottom_view.frame=CGRectMake(0, self.view.bounds.size.height-44, 320, 44);
        [self.bottom_view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.bottom_view setBlurTintColor:nil];
        [self.view addSubview:self.bottom_view];
        
        UIButton *feedback_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        feedback_btn.frame = CGRectMake(5, 5, 200, 34);
        [feedback_btn setTitle:@"说两句呗" forState:UIControlStateNormal];
        feedback_btn.backgroundColor=[UIColor whiteColor];
        feedback_btn.tintColor=[UIColor grayColor];
        [feedback_btn.layer setMasksToBounds:YES];
        [feedback_btn.layer setCornerRadius:10.0];
        [feedback_btn.layer setBorderWidth:0.2];
        feedback_btn.tintColor=[UIColor blackColor];
        [feedback_btn addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom_view addSubview:feedback_btn];
        
//        UIButton *share_btn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-5-34-34,5,34,34)];
//        [share_btn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
//        [share_btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottom_view addSubview:share_btn];
        
        _collect_btn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-5-34,5,34,34)];
        if(_article.is_collected){
            [_collect_btn setBackgroundImage:[UIImage imageNamed:@"star_on.png"] forState:UIControlStateNormal];
        }else{
            [_collect_btn setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        }
        [_collect_btn addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom_view addSubview:_collect_btn];
    }
    isFirst=YES;
}
-(void)feedback{
    FeedBackViewController *controller=[[FeedBackViewController alloc] init];
    controller.article=_article;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)back{
    if([self.navigationController.viewControllers indexOfObject:self]!=0){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)clicked{
    [self.touchView hide];
    [self.waitingView show];
    if(_article==nil){
        [self loadPushArticleFromNet];
    }else{
        [self loadArticleContentFromNet];
    }
}
-(void)loadPushArticleFromNet{
    [_service fetchOneArticleWithArticleID:_pushArticleID successHandler:^(Article *article) {
        _article=article;
        self.popupMenuView.favor_status=NO;
        NSString *path=[[NSBundle mainBundle] pathForResource:@"article" ofType:@"html"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        [self.waitingView hide];
    } errorHandler:^(NSError *error) {
        [self.waitingView hide];
        [self.touchView show];
    }];
}
-(void)loadArticleContentFromNet{
    [_service fetchArticleContentWithArticle:_article successHandler:^(BOOL is_ok) {
        NSLog(@"%@",_article.page_path);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_article.page_path]]];
        [self.waitingView hide];
        [self.touchView hide];
    } errorHandler:^(NSError *error) {
        [self.waitingView hide];
        [self.touchView show];
    }];
}
-(void)initBridge{
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"bridge is ok");
    }];
    [_bridge registerHandler:@"openAd" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self navToAdArticleVC];
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeOther) {
        NSLog(@"shouldStartLoadWithRequest");
        
    }
    return YES;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"open player viewWillLayoutSubviews");
}
BOOL isFirst=YES;
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [_waitingView hide];
    if(isFirst){
        isFirst=NO;
        NSString *js_init_bridge=@"document.addEventListener('WebViewJavascriptBridgeReady', function onBridgeReady(event) {bridge = event.bridge;bridge.init(function(message,responseCallback) {alert('Received message: ' + message);if (responseCallback) {responseCallback('Right back atcha')};});bridge.send('Hello from the javascript');bridge.send('Please respond to this', function responseCallback(responseData) {console.log('Javascript got its response',responseData);});}, false);";
        [webView stringByEvaluatingJavaScriptFromString:js_init_bridge];
        NSString *js_insert_visit_number=[NSString stringWithFormat:@"var visit=document.createElement('span');document.getElementById('main').childNodes[1].appendChild(visit);visit.setAttribute('style','float:right;margin-right:10px');visit.textContent='访问量:%d';",_article.visit_number.intValue];
        NSString *js_insert_ad=[NSString stringWithFormat:@"var ad=document.createElement('div');document.getElementById('main').appendChild(ad);ad.style.textAlign='center';ad.style.fontSize='9px';ad.style.color='gray';var ul=document.createElement('div');var li_tip=document.createElement('div');var li_ad=document.createElement('div');ad.appendChild(ul);ul.appendChild(li_tip);ul.appendChild(li_ad);li_tip.textContent='赞助商提供';pic=document.createElement('img');pic.src='%@';li_ad.appendChild(pic);pic.onclick=function(){if(bridge){bridge.callHandler('openAd','',null)};}",_ad_article.cover_image_url];
        NSString *js_insert_bottom=[NSString stringWithFormat:@"var btm=document.createElement('div');document.getElementById('main').appendChild(btm);btm.style.height='44px';"];
        NSString *js_video=@"var video_element=document.getElementsByTagName('video')[0]; video_element.setAttribute('webkit-playsinline','true')";
        [webView stringByEvaluatingJavaScriptFromString:js_insert_visit_number];
//        if(_ad_article!=nil){
//            [webView stringByEvaluatingJavaScriptFromString:js_insert_ad];
//        }
        [webView stringByEvaluatingJavaScriptFromString:js_insert_bottom];
        [webView stringByEvaluatingJavaScriptFromString:js_video];
        [self changeWebContentWithWebView:webView];
    }
}
-(void)showMenu{
    [self.popupMenuView show];
}



#pragma mark -



#pragma mark - fond size change
-(void)changeWebContentWithWebView:(UIWebView *)webView{
    NSString *strFontSize=AppDelegate.user_defaults.font_size;
    if([strFontSize isEqualToString:@"特大"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"];
    }else if([strFontSize isEqualToString:@"较大"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'"];
    }else if([strFontSize isEqualToString:@"正常"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    }else if([strFontSize isEqualToString:@"较小"]){
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'"];
    }
}
-(void)changeFontWithFontSize:(NSString *)fontSize{
    // [self changeWebContentFontSize:fontSize webView:self.webView];
    AppDelegate.user_defaults.font_size=fontSize;
}
-(void)font{
    [self.fontAlertView show];
}
#pragma mark - ad insert
-(void)navToAdArticleVC{
    Article *article_ad=[_service fetchADArticleFromDB];
    ArticleViewController *controller=[[ArticleViewController alloc] initWithAritcle:article_ad];
    controller.isAD=YES;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - collect article
-(void)collect{
    if(_article.is_collected){
        _article.is_collected=NO;
        [_collect_btn setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        [_service markArticleCollectedWithArticle:_article is_collected:NO];
        [self.view.window showHUDWithText:@"已取消收藏" Type:ShowPhotoYes Enabled:YES];
    }else{
        _article.is_collected=YES;
        [_collect_btn setBackgroundImage:[UIImage imageNamed:@"star_on.png"] forState:UIControlStateNormal];
        [_service markArticleCollectedWithArticle:_article is_collected:YES];
        [self.view.window showHUDWithText:@"收藏成功" Type:ShowPhotoYes Enabled:YES];
    }
}


#pragma mark - share article
-(void)share{
    FrontiaShare *share = [Frontia getShare];
    
    [share registerQQAppId:@"100358052" enableSSO:NO];
    [share registerWeixinAppId:@"wx712df8473f2a1dbe"];
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
    };
    
    //授权成功回调函数
    FrontiaMultiShareResultCallback onResult = ^(NSDictionary *respones){
        NSLog(@"OnResult: %@", [respones description]);
    };
    
    
    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
    content.url = _article.page_url;
    content.title = _article.article_title;
    content.description = _article.summary;
    content.imageObj = _article.thumbnail_url;
    
    //    NSArray *platforms = @[FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQ,FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN,FRONTIA_SOCIAL_SHARE_PLATFORM_KAIXIN,FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,FRONTIA_SOCIAL_SHARE_PLATFORM_SMS];
    NSArray *platforms = @[FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQ,FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN,FRONTIA_SOCIAL_SHARE_PLATFORM_KAIXIN,FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,FRONTIA_SOCIAL_SHARE_PLATFORM_QQFRIEND,FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,FRONTIA_SOCIAL_SHARE_PLATFORM_SMS,FRONTIA_SOCIAL_SHARE_PLATFORM_COPY];
    [share showShareMenuWithShareContent:content displayPlatforms:platforms supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO targetViewForPad:self.view cancelListener:onCancel failureListener:onFailure resultListener:onResult];
}
#pragma mark - like article
-(void)showComments{
    CommentsViewController *vc=[[CommentsViewController alloc] init];
    vc.service=_service;
    vc.article=_article;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - visit_numner insert
- (void)enterFullScreen:(NSNotification *)notification {// 开始播放
    NSLog(@"videoStarted");
    AppDelegate.is_full = YES;
}
- (void)exitFullScreen:(NSNotification *)notification {//完成播放
    NSLog(@"videoFinished");
    AppDelegate.is_full =NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
