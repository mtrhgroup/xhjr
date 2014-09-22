//
//  PeriodicalContentViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 13-3-4.
//
//

#import "PeriodicalContentViewController.h"
#import "XDailyItem.h"

@interface PeriodicalContentViewController ()

@end

@implementation PeriodicalContentViewController{
    UIWebView *_webView;
    NewsManager *_manager;
    UILabel *_titleLabel;
    UIView *_waitingView;
    UIActivityIndicatorView *_activity;
}
- (id)init
{
    self = [super init];
    if (self) {
        _manager=[[NewsManager alloc]init];
        _manager.delegate=self;
        _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
        _webView.delegate=self;
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 40)];
        _titleLabel.text = @"title";
        _titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        [self makeWaitingView];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIView* booktopView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320,416)];
    booktopView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bigtablebg.png"]];
    [self.view addSubview:booktopView];
    
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [bimgv addSubview:_titleLabel];
    [self.view addSubview:bimgv];
    [self.view addSubview:_webView];
    [self.view setBackgroundColor:[UIColor whiteColor]];  
}
-(void)loadWithXdaily:(XDailyItem *)item{
    NSLog(@"%@",item.title);
    _titleLabel.text=item.title;
    [_manager fetchNewsContentWithXdaily:item];
    [self showWaitingView];
    NSLog(@"$$$");
}

-(void)didReceiveNewsContent:(XDailyItem *)xdaily{
    NSURL *url=[NSURL fileURLWithPath:[xdaily localPath]];
    NSLog(@"%@",url);
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}
- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return  YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(hideWaitingView) withObject:nil afterDelay:0.2];
}
-(void)makeWaitingView{
    _waitingView=[[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 460)];
    _waitingView.backgroundColor=[UIColor colorWithWhite:1 alpha:1];
    _waitingView.hidden=true;
    _activity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 100, 32, 32)];
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 150, 231, 65)];
    imageView.image=[UIImage imageNamed:@"logo.png"];
    [_waitingView addSubview:imageView];
    [_waitingView addSubview:_activity];
    [self.view addSubview:_waitingView];
    
}
-(void)showWaitingView{
    [_activity startAnimating];
    _waitingView.hidden=false;
}
-(void)hideWaitingView{
    [_activity stopAnimating];
    _waitingView.hidden=true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
