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
@interface ArticleViewController (){
    Article *_article;
    Service *_service;
    Article * _adArticle;
    NSString *_pushArticleID;
    NSArray *fonts;
    int offset;
}
@property WebViewJavascriptBridge* bridge;
@end

@implementation ArticleViewController
@synthesize waitingView=_waitingView;
@synthesize popupMenuView=_popupMenuView;
@synthesize fontAlertView=_fontAlertView;
@synthesize isAD=_isAD;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate=self;
    [self.view addSubview:self.webView];
    self.waitingView=[[WaitingView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.waitingView];
    self.touchView=[[TouchRefreshView alloc]initWithFrame:self.view.bounds];
    self.touchView.delegate=self;
    [self.view addSubview:self.touchView];
    [_service markArticleReadWithArticle:_article];
    if(_article==nil){
        [self loadPushArticleFromNet];
    }else{
        if(!_article.is_cached){
            [self.waitingView show];
            [self loadArticleContentFromNet];
        }else{
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_article.page_path]]];
            [self initBridge];
        }
    }
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"ic_menu_normal.png"] target:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.fontAlertView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 240)];
    self.fontAlertView.titleName.text = @"选择字体大小";
    self.fontAlertView.web_delegate=self;
    [self.fontAlertView setSelectedFontSize:_service.fontSize];
    
    self.popupMenuView=[[PopupMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.popupMenuView.delegate=self;
    self.popupMenuView.favor_status=_article.is_collected;
    [self.view addSubview:self.popupMenuView];
}

-(void)clickedWithArticle:(Article *)article{
    ArticleViewController *controller=[[ArticleViewController alloc] initWithAritcle:article];
    controller.isAD=YES;
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
        [self initBridge];
        [self.waitingView hide];
    } errorHandler:^(NSError *error) {
        [self.waitingView hide];
        [self.touchView show];
    }];
}
-(void)loadArticleContentFromNet{    
    [_service fetchArticleContentWithArticle:_article successHandler:^(BOOL is_ok) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_article.page_path]]];
        [self initBridge];
        [self.waitingView hide];
    } errorHandler:^(NSError *error) {
        [self.waitingView hide];
        [self.touchView show];
    }];
}
-(void)initBridge{
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];

    [_bridge registerHandler:@"openAd" handler:^(id data, WVJBResponseCallback responseCallback) {
        if(_adArticle){
            ArticleViewController *controller=[[ArticleViewController alloc] initWithAritcle:_adArticle];
            controller.isAD=YES;
           [self.navigationController pushViewController:controller animated:YES];
            
        }
    }];

}
-(void)appendInsideAD{
    Article *article_ad=[_service fetchADArticleFromDB];
    if(article_ad.thumbnail_url!=nil&&![article_ad.thumbnail_url isEqual:@""]){
        _adArticle=article_ad;
        [_bridge callHandler:@"appendAd" data:article_ad.thumbnail_url];
    }
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_waitingView hide];
}
-(void)showMenu{
    [self.popupMenuView show];
}
-(void)favor{
    _article.is_collected=YES;
    [_service markArticleCollectedWithArticle:_article is_collected:YES];
    [self.view.window showHUDWithText:@"收藏成功" Type:ShowPhotoYes Enabled:YES];
}
-(void)unfavor{
    _article.is_collected=NO;
    [_service markArticleCollectedWithArticle:_article is_collected:NO];
    [self.view.window showHUDWithText:@"已取消收藏" Type:ShowPhotoYes Enabled:YES];
}
-(void)font{    
    [self.fontAlertView show];
}
-(void)changeWebContentFontSize:(NSString *)strFontSize webView:(UIWebView *)webView{
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
#pragma mark -


-(void)changeFontWithFontSize:(NSString *)fontSize{
    [self changeWebContentFontSize:fontSize webView:self.webView];
    _service.fontSize=fontSize;
}
@end
