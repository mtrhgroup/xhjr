//
//  OnlineWebViewController.m
//  XinHuaDailyXib
//
//  Created by 张健 on 15-2-9.
//
//

#import "OnlineWebViewController.h"
#import "WaitingView.h"
#import "NavigationController.h"
@interface OnlineWebViewController ()
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)WaitingView *waitingView;
@property(nonatomic,strong)RefreshTouchView *touchView;
@property(nonatomic,strong)UIButton *refresh_btn;
@end

@implementation OnlineWebViewController
@synthesize url=_url;
@synthesize webView=_webView;
@synthesize waitingView=_waitingView;
@synthesize touchView=_touchView;
@synthesize refresh_btn=_refresh_btn;
@synthesize top_name=_top_name;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.top_name;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-20-44)];
    [self.webView setAllowsInlineMediaPlayback:YES];
    self.webView.delegate=self;
    self.webView.allowsInlineMediaPlayback=YES;
    [self.view addSubview:self.webView];
    self.waitingView=[[WaitingView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.waitingView];
    self.touchView=[[RefreshTouchView alloc]initWithFrame:self.view.bounds];
    self.touchView.delegate=self;
    [self.view addSubview:self.touchView];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.refresh_btn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,44,44)];
    [self.refresh_btn setBackgroundImage:[UIImage imageNamed:@"button_refresh_normal.png"] forState:UIControlStateNormal];
    [self.refresh_btn addTarget:self action:@selector(loadURL) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refresh_btn_item=[[UIBarButtonItem alloc] initWithCustomView:self.refresh_btn];
    UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if(lessiOS7){
        negativeSpacer.width=0;
    }else{
        negativeSpacer.width=-10;
    }
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,refresh_btn_item,nil] animated:YES];
    [self loadURL];
}
-(void)back{
    if([self.navigationController.viewControllers indexOfObject:self]!=0){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        CATransition *animation = [CATransition animation];
        animation.duration = 0.4;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype=kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
-(void)loadURL{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_waitingView hide];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchViewClicked{
    [self.touchView hide];
    [self.waitingView show];
    [self loadURL];
}
@end
