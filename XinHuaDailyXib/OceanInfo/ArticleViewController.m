#import "ArticleViewController.h"
#import "NavigationController.h"
#import "UIWindow+YzdHUD.h"
#import "RefreshTouchView.h"
#import "AMBlurView.h"
#import "FeedBackViewController.h"
#import "CommentsViewController.h"
#import "UIPlaceHolderTextView.h"
#import "UIButton+Bootstrap.h"
#import "Math.h"
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
@property(nonatomic,strong)UIButton *like_btn;
@property(nonatomic,strong)UILabel *comment_number_label;
@property(nonatomic,strong)UIButton *collect_btn;
@property(nonatomic,assign)BOOL isAD;
@property(nonatomic,strong)Article *ad_article;
@property (nonatomic,strong)AMBlurView *bottom_view;
@property (nonatomic,strong) AMBlurView *blurView;
@property(nonatomic,strong)UITextView *contentTV;
@property(nonatomic,strong)UIButton *send_btn;
@property(nonatomic,strong)UIButton *cancel_btn;
@end

@implementation ArticleViewController
@synthesize waitingView=_waitingView;
@synthesize popupMenuView=_popupMenuView;
@synthesize fontAlertView=_fontAlertView;
@synthesize isAD=_isAD;
@synthesize comment_btn=_comment_btn;
@synthesize like_btn=_like_btn;
@synthesize comment_number_label=_comment_number_label;
@synthesize collect_btn=_collect_btn;
@synthesize bridge=_bridge;
@synthesize ad_article=_ad_article;
@synthesize article=_article;
@synthesize service=_service;
- (id)initWithAritcle:(Article *)article
{
    self = [super init];
    if (self) {
        _service=AppDelegate.service;
        _article=article;
        _isAD=NO;
        fonts=[NSArray arrayWithObjects:@"特大",@"较大",@"正常",@"较小",nil];
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

-(void)dealloc{
    [self unregNotification];
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
    if(_article.is_like){
        _like_btn.enabled=NO;
        [_like_btn setBackgroundImage:[UIImage imageNamed:@"button_wonderful_pressdown.png"] forState:UIControlStateNormal];
    }
    [self regNotification];
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
        UIButton *comments_btn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,44,44)];
        [comments_btn setBackgroundImage:[UIImage imageNamed:@"button_review_default.png"] forState:UIControlStateNormal];
        [comments_btn addTarget:self action:@selector(showComments) forControlEvents:UIControlEventTouchUpInside];
        
        _like_btn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,44,44)];
        [_like_btn setBackgroundImage:[UIImage imageNamed:@"button_wonderful_default.png"] forState:UIControlStateNormal];
        [_like_btn addTarget:self action:@selector(likeArticle) forControlEvents:UIControlEventTouchUpInside];
        
        
        if(_article.is_like){
            _like_btn.enabled=NO;
            [_like_btn setBackgroundImage:[UIImage imageNamed:@"button_wonderful_pressdown.png"] forState:UIControlStateNormal];
        }
        UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        if(lessiOS7){
            negativeSpacer.width=0;
        }else{
            negativeSpacer.width=-10;
        }
        UIBarButtonItem *comments_btn_item=[[UIBarButtonItem alloc] initWithCustomView:comments_btn];
         UIBarButtonItem *like_btn_item=[[UIBarButtonItem alloc] initWithCustomView:_like_btn];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,comments_btn_item,like_btn_item,nil] animated:YES];
        
        self.bottom_view=[AMBlurView new];
        NSLog(@"view bounds height:%f   frame height:%f",self.view.bounds.size.height,self.view.frame.size.height);
       self.bottom_view.frame=CGRectMake(0, (lessiOS7)?self.view.bounds.size.height-88:self.view.bounds.size.height-88-20, 320, 44);
        NSLog(@"%f",self.bottom_view.frame.origin.y);
        [self.view addSubview:self.bottom_view];
        
        UIButton *feedback_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        feedback_btn.frame = CGRectMake(5, 5, self.bottom_view.bounds.size.width-10, 34);
        [feedback_btn setTitle:@"说两句呗" forState:UIControlStateNormal];
        feedback_btn.backgroundColor=[UIColor whiteColor];
        feedback_btn.tintColor=[UIColor grayColor];
        [feedback_btn.layer setMasksToBounds:YES];
        [feedback_btn.layer setCornerRadius:10.0];
        [feedback_btn.layer setBorderWidth:0.2];
        feedback_btn.tintColor=[UIColor blackColor];
        [feedback_btn addTarget:self action:@selector(showEditCommentView) forControlEvents:UIControlEventTouchUpInside];
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
//        [self.bottom_view addSubview:_collect_btn];
    }
    isFirst=YES;
    
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(0, (lessiOS7)?self.view.frame.size.height-180-44:self.view.frame.size.height-180-25, self.view.bounds.size.width, 180)];
    self.blurView.hidden=YES;
    [self.view addSubview:[self blurView]];
    
    
    UIPlaceHolderTextView* content = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 50, 280, 120)];
    // content.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    content.layer.cornerRadius = 10.0f;
    [content setFont:[UIFont systemFontOfSize:17 ]];
    content.layer.borderWidth = 0.2f;
    content.backgroundColor=[UIColor clearColor];
    content.layer.borderColor = [[UIColor grayColor] CGColor];
    content.placeholder = @"请文明发言";
    content.placeholderColor=[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
    content.delegate=self;
    content.contentInset = UIEdgeInsetsMake(2,2,2,2);
    self.contentTV=content;
    [self.blurView addSubview:content];
    //[self.contentTV becomeFirstResponder];
    self.cancel_btn=[[UIButton alloc] initWithFrame:CGRectMake(20, 5, 100, 40)];
    [self.cancel_btn dangerStyle];
    [self.cancel_btn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancel_btn addTarget:self action:@selector(hideEditCommentView) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView addSubview:self.cancel_btn];
    self.send_btn=[[UIButton alloc] initWithFrame:CGRectMake(self.blurView.frame.size.width-100-20,5, 100, 40)];
    [self.send_btn dangerStyle];
    [self.send_btn setTitle:@"发送" forState:UIControlStateNormal];
    [self.send_btn addTarget:self action:@selector(send_Message) forControlEvents:UIControlEventTouchUpInside];
    self.send_btn.enabled=NO;
    [self.blurView addSubview:self.send_btn];
}
-(void)showEditCommentView{
    self.contentTV.text=@"";
    self.blurView.hidden=NO;
    [self.contentTV becomeFirstResponder];

}
-(void)hideEditCommentView{
    [self.contentTV resignFirstResponder];
}
-(void)feedback{
    FeedBackViewController *controller=[[FeedBackViewController alloc] init];
    controller.article=_article;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)back{
     [self.contentTV resignFirstResponder];
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

BOOL isFirst=YES;
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [_waitingView hide];
    if(isFirst){
        isFirst=NO;
        NSString *js_init_bridge=@"document.addEventListener('WebViewJavascriptBridgeReady', function onBridgeReady(event) {bridge = event.bridge;bridge.init(function(message,responseCallback) {alert('Received message: ' + message);if (responseCallback) {responseCallback('Right back atcha')};});bridge.send('Hello from the javascript');bridge.send('Please respond to this', function responseCallback(responseData) {console.log('Javascript got its response',responseData);});}, false);";
        [webView stringByEvaluatingJavaScriptFromString:js_init_bridge];
        NSString *js_insert_visit_number=[NSString stringWithFormat:@"var visit=document.createElement('span');document.getElementById('main').childNodes[1].appendChild(visit);visit.setAttribute('style','float:right;margin-right:10px');visit.textContent='访问量:%d';",_article.visit_number.intValue];
        NSString *js_insert_ad=[NSString stringWithFormat:@"var ad=document.createElement('div');document.getElementById('main').appendChild(ad);ad.style.textAlign='center';ad.style.fontSize='9px';ad.style.color='gray';var ul=document.createElement('div');var li_tip=document.createElement('div');var li_ad=document.createElement('div');ad.appendChild(ul);ul.appendChild(li_tip);ul.appendChild(li_ad);li_tip.textContent='赞助商提供';pic=document.createElement('img');pic.src='%@';li_ad.appendChild(pic);pic.onclick=function(){if(bridge){bridge.callHandler('openAd','',null)};}",_ad_article.cover_image_url];
        NSString *js_insert_bottom=[NSString stringWithFormat:@"var btm=document.createElement('div');document.getElementById('main').appendChild(btm);btm.style.height='54px';"];
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
-(void)send_Message{
    NSString *contentStr=self.contentTV.text;
    if(contentStr==nil||[contentStr isEqualToString:@""]){
        //[self showAlertText:@"请输入内容"];
        return;
    }
    [self.service feedbackArticleWithContent:contentStr article:self.article successHandler:^(BOOL is_ok) {
        [self.contentTV resignFirstResponder];
        [self.view.window showHUDWithText:@"发送成功" Type:ShowPhotoYes Enabled:YES];
        [self changeCommentsNumber];
    } errorHandler:^(NSError *error) {
        [self.view.window showHUDWithText:error.localizedDescription Type:ShowPhotoNo Enabled:YES];
    }];
}
- (void)textViewDidChange:(UITextView *)textView{
    NSString *contentStr=self.contentTV.text;
    if(contentStr==nil||[contentStr isEqualToString:@""]){
       // [self showAlertText:@"请输入内容"];
        self.send_btn.enabled=NO;
        return;
    }
    self.send_btn.enabled=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self unregNotification];
    
}
-(void)changeCommentsNumber{
    [self.service fetchCommentsNumberFromNETWith:self.article successHandler:^(NSNumber *comments_number) {
        self.article.comments_number=comments_number;
        _comment_number_label.text=[NSString stringWithFormat:@"%d",_article.comments_number.intValue];
    } errorHandler:^(NSError *error) {
       // <#code#>
    }];
}
- (void)showAlertText:(NSString*)string
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alert show];
}
- (void)regNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)unregNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)notification{
    self.blurView.hidden=NO;
}
-(void)keyboardWillHide:(NSNotification *)notification{
    self.blurView.hidden=YES;
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    CGRect inputFieldRect = self.blurView.frame;
    inputFieldRect.origin.y += yOffset;
    [UIView animateWithDuration:duration animations:^{
        self.blurView.frame = inputFieldRect;
    }];
}

-(void)likeArticle{
    [_service likeArticleWithArticle:_article successHandler:^(NSString *like_number) {
        [_like_btn setBackgroundImage:[UIImage imageNamed:@"button_wonderful_pressdown.png"] forState:UIControlStateNormal];
        _like_btn.enabled=NO;
        _article.is_like=YES;
        _article.like_number=[NSNumber numberWithInteger:like_number.integerValue];
        [_service markArticleLikeWithArticle:_article];
    } errorHandler:^(NSError *error) {
        //<#code#>
    }];
}
@end
