//
//  InstantContentViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 13-3-4.
//
//

#import "InstantContentViewController.h"
#import "XDailyItem.h"

@interface InstantContentViewController ()

@end

@implementation InstantContentViewController{
    UIWebView *_webView;
    NewsManager *_manager;
    UILabel *_titleLabel;
}
- (id)init
{
    self = [super init];
    if (self) {
        _manager=[[NewsManager alloc]init];
        _manager.delegate=self;
        _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 40)];
        _titleLabel.text = @"title";
        _titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
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
    NSLog(@"###");
    _titleLabel.text=item.title;
    [_manager fetchNewsContentWithXdaily:item];
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return  YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
