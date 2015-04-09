//
//  KidsContentViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/10.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "ArticleViewController.h"
#import "NavigationController.h"
#import "UIWindow+YzdHUD.h"
#import "RefreshTouchView.h"
#import "AMBlurView.h"
#import "FeedBackToEditorViewController.h"
#import "UIPlaceHolderTextView.h"
#import "UIButton+Bootstrap.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
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
@property(nonatomic,strong)UILabel *like_number_label;
@property(nonatomic,strong)UIButton *collect_btn;
@property(nonatomic,assign)BOOL isAD;
@property(nonatomic,strong)Article *ad_article;
@property (nonatomic,strong)AMBlurView *bottom_view;
@property(nonatomic,strong)UIButton *like_btn;

@property (nonatomic,strong) AMBlurView *blurView;
@property(nonatomic,strong)UITextView *contentTV;
@property(nonatomic,strong)UIButton *send_btn;
@property(nonatomic,strong)UIButton *cancel_btn;
@property(nonatomic,strong)NSMutableArray *photos;
@end

@implementation ArticleViewController
@synthesize photos=_photos;
@synthesize waitingView=_waitingView;
@synthesize popupMenuView=_popupMenuView;
@synthesize fontAlertView=_fontAlertView;
@synthesize isAD=_isAD;
@synthesize comment_btn=_comment_btn;
@synthesize like_number_label=_like_number_label;
@synthesize collect_btn=_collect_btn;
@synthesize bridge=_bridge;
@synthesize ad_article=_ad_article;
@synthesize like_btn=_like_btn;
@synthesize channel_name=_channel_name;
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
    }
    return self;
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
    _ad_article=[_service fetchADArticleFromDB];
    if(_article.is_like){
        _like_btn.enabled=NO;
        _like_number_label.text=[NSString stringWithFormat:@"%d",_article.like_number.intValue];
        [_like_btn setBackgroundImage:[UIImage imageNamed:@"button_wonderful_pressdown.png"] forState:UIControlStateNormal];
    }
    [self regNotification];
    self.title=self.channel_name;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self unregNotification];
    
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
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.fontAlertView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 240)];
    self.fontAlertView.titleName.text = @"选择字体大小";
    self.fontAlertView.web_delegate=self;
    [self.fontAlertView setSelectedFontSize:AppDelegate.user_defaults.font_size];
    if(!self.isAD){
        UIView *like_view=[[UIView alloc] initWithFrame:CGRectMake(0,0,68,34)];
        _like_number_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 34, 24)];
        _like_number_label.text=[NSString stringWithFormat:@"%d",_article.like_number.intValue];
        _like_number_label.textAlignment=NSTextAlignmentRight;
        _like_number_label.textColor=[UIColor grayColor];
        _like_number_label.backgroundColor=[UIColor clearColor];
        _like_number_label.font = [UIFont fontWithName:@"Arial" size:10];
        _like_btn=[[UIButton alloc]initWithFrame:CGRectMake(34,0,34,34)];
        [_like_btn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [_like_btn addTarget:self action:@selector(likeArticle) forControlEvents:UIControlEventTouchUpInside];
        [like_view addSubview:_like_btn];
        [like_view addSubview:_like_number_label];
        if(_article.is_like){
            _like_btn.enabled=NO;
            [_like_btn setBackgroundImage:[UIImage imageNamed:@"like_on.png"] forState:UIControlStateNormal];
        }
        UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        if(lessiOS7){
            negativeSpacer.width=0;
        }else{
            negativeSpacer.width=-10;
        }
        UIBarButtonItem *like_btn_item=[[UIBarButtonItem alloc] initWithCustomView:like_view];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,like_btn_item,nil] animated:YES];

        self.bottom_view=[AMBlurView new];
        self.bottom_view.frame=CGRectMake(0, self.view.bounds.size.height-44, 320, 44);
        [self.bottom_view setBlurTintColor:nil];
        [self.view addSubview:self.bottom_view];
        
        UIButton *feedback_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        feedback_btn.frame = CGRectMake(5, 5, 200, 34);
        [feedback_btn setTitle:@"有话对编辑说" forState:UIControlStateNormal];
        feedback_btn.backgroundColor=[UIColor whiteColor];
        feedback_btn.tintColor=[UIColor grayColor];
        [feedback_btn.layer setMasksToBounds:YES];
        [feedback_btn.layer setCornerRadius:10.0];
        [feedback_btn.layer setBorderWidth:0.2];
        feedback_btn.tintColor=[UIColor blackColor];
        [feedback_btn addTarget:self action:@selector(showEditCommentView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom_view addSubview:feedback_btn];
        
        UIButton *share_btn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-5-34-34,5,34,34)];
        [share_btn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [share_btn addTarget:self action:@selector(shareArticle) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom_view addSubview:share_btn];
        
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
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(0,self.view.frame.size.height-180, self.view.bounds.size.width, 180)];
    self.blurView.hidden=YES;
    [self.view addSubview:[self blurView]];
    
    
    UIPlaceHolderTextView* content = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 50, self.view.bounds.size.width-40, 120)];
    // content.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    content.layer.cornerRadius = 10.0f;
    [content setFont:[UIFont systemFontOfSize:17 ]];
    content.layer.borderWidth = 0.2f;
    content.backgroundColor=[UIColor clearColor];
    content.layer.borderColor = [[UIColor grayColor] CGColor];
    content.placeholder = @"写评论";
    content.placeholderColor=[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
    content.delegate=self;
    content.contentInset = UIEdgeInsetsMake(2,2,2,2);
    self.contentTV=content;
    [self.blurView addSubview:content];
    //[self.contentTV becomeFirstResponder];
    self.cancel_btn=[[UIButton alloc] initWithFrame:CGRectMake(20, 5, 100, 40)];
    [self.cancel_btn primaryStyle];
    [self.cancel_btn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancel_btn addTarget:self action:@selector(hideEditCommentView) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView addSubview:self.cancel_btn];
    self.send_btn=[[UIButton alloc] initWithFrame:CGRectMake(self.blurView.frame.size.width-100-20,5, 100, 40)];
    [self.send_btn primaryStyle];
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
    FeedBackToEditorViewController *controller=[[FeedBackToEditorViewController alloc] init];
    controller.article=_article;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)back{
    if(self.isAD)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
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
    [_bridge registerHandler:@"showImages" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *file_path=[((NSDictionary *)data) objectForKey:@"file"];
        [self showImagesWithFile:file_path];
    }];
    
}
-(void)showImagesWithFile:(NSString *)file_path{
    
    NSString *file_path_removePrefix=[file_path substringFromIndex:7];
    self.photos = [NSMutableArray array];
    [self.photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:file_path_removePrefix]]];
    
    //[self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://www.baidu.com/img/bd_logo1.png"]]];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.wantsFullScreenLayout = YES; // iOS 5 & 6 only: Decide if you want the photo browser full screen, i.e. whether the status
    [browser setCurrentPhotoIndex:1];
    
    [self.navigationController pushViewController:browser animated:YES];
    
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:10];
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
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
        NSString *js_insert_visit_number=[NSString stringWithFormat:@"var visit=document.createElement('span');document.getElementById('main').childNodes[1].appendChild(visit);visit.setAttribute('style','float:right;margin-right:10px');visit.textContent='访问量:%d';",_article.visit_number.intValue+25];
        NSString *js_insert_ad=[NSString stringWithFormat:@"var ad=document.createElement('div');document.getElementById('main').appendChild(ad);ad.style.textAlign='center';ad.style.fontSize='9px';ad.style.color='gray';var ul=document.createElement('div');var li_tip=document.createElement('div');var li_ad=document.createElement('div');ad.appendChild(ul);ul.appendChild(li_tip);ul.appendChild(li_ad);li_tip.textContent='赞助商提供';pic=document.createElement('img');pic.src='%@';li_ad.appendChild(pic);pic.onclick=function(){if(bridge){bridge.callHandler('openAd','',null)};}",_ad_article.cover_image_url];
        NSString *js_insert_bottom=[NSString stringWithFormat:@"var btm=document.createElement('div');document.getElementById('main').appendChild(btm);btm.style.height='44px';"];
        NSString *js_video=@"var video_element=document.getElementsByTagName('video')[0]; video_element.setAttribute('webkit-playsinline','true')";
        NSString *js_add_imgOpenAction=@"var img_elements=document.getElementsByTagName('img');for(var i=0;i<img_elements.length;i++){var img_src=img_elements[i].src;img_elements[i].onclick=function(){if(bridge){bridge.callHandler('showImages',{'file':this.src},null);}};}";
        [webView stringByEvaluatingJavaScriptFromString:js_add_imgOpenAction];
        [webView stringByEvaluatingJavaScriptFromString:js_insert_visit_number];
        if(_ad_article!=nil){
            [webView stringByEvaluatingJavaScriptFromString:js_insert_ad];
        }
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
-(void)shareArticle{
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
    [_service likeArticleWithArticle:_article successHandler:^(NSString *like_number) {
        _like_number_label.text=like_number;
        [_comment_btn setBackgroundImage:[UIImage imageNamed:@"like_on.png"] forState:UIControlStateNormal];
        _comment_btn.enabled=NO;
        _article.is_like=YES;
        _article.like_number=[NSNumber numberWithInteger:like_number.integerValue];
        [_service markArticleLikeWithArticle:_article];
    } errorHandler:^(NSError *error) {
        //<#code#>
    }];
}

- (void)regNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
float keyBoardHeight;
-(void)keyboardWillShow:(NSNotification *)notification{
    self.blurView.hidden=NO;
    CGRect keyBoardRect=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    NSLog(@"%f",deltaY);
    keyBoardHeight=deltaY;
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.blurView.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.blurView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    self.blurView.hidden=YES;
}

-(void)likeArticle{
    [_service likeArticleWithArticle:_article successHandler:^(NSString *like_number) {
        [_like_btn setBackgroundImage:[UIImage imageNamed:@"like_on.png"] forState:UIControlStateNormal];
        _like_btn.enabled=NO;
        _article.is_like=YES;
        _article.like_number=[NSNumber numberWithInteger:like_number.integerValue];
        _like_number_label.text=[NSString stringWithFormat:@"%d",_article.like_number.intValue];
        [_service markArticleLikeWithArticle:_article];
    } errorHandler:^(NSError *error) {
        //<#code#>
    }];
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
@end
