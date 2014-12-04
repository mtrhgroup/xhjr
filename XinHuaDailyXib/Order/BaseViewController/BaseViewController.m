//
//  BaseViewController.m
//  YourOrder
//
//  Created by 胡世骞 on 14/12/2.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+Hex.h"
#import "ASIFormDataRequest.h"
@interface BaseViewController ()<ASIHTTPRequestDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"classname:%@",[NSString stringWithUTF8String:object_getClassName(self)]);
    //    [MAPStatistics event:@"BaseViewController" sign:[NSString stringWithUTF8String:object_getClassName(self)]];
    self.view.backgroundColor = [UIColor clearColor];
    CGRect rect = [UIScreen mainScreen].bounds;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >=7.0000) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, rect.size.width, rect.size.height - 20)];
    }else {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 20)];
    }
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    
    [self.view addSubview:_bgView];
    
    if (self.navigationView == nil) {
        _navigationView = [[XHHeadView alloc] init];
        [_navigationView initView];
        [_bgView addSubview:_navigationView];
    }
    rect = _bgView.frame;
    rect.origin.y = 44;
    rect.size.height -= 44;
    _baseView = [[UIView alloc] initWithFrame:rect];
    [_bgView addSubview:_baseView];
}

- (XHHeadView*)navigationView
{
    if (_navigationView == nil) {
        _navigationView = [[XHHeadView alloc] init];
        [_navigationView initView];
        [_bgView addSubview:_navigationView];
    }
    return _navigationView;
}

- (NSString*)getCurrentTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc ]  init ];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayTime = [formatter stringFromDate:today];
    return todayTime;
}

//开始请求数据
- (void)requestDataWithUrl:(NSString*)urlString andPostData:(NSString*)postData
{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
