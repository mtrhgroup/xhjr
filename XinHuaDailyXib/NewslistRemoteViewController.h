//
//  NewslistRemoteViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewslistRemoteViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong,nonatomic)UIView *waitingView;
@property (strong,nonatomic)UIActivityIndicatorView *indicator;
//输入变量
@property (strong,nonatomic)NSString *url;
@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *channel_title;
@property (strong,nonatomic)NSString *channel_id;
//输出变量
@property (strong,nonatomic)NSMutableArray *newslist;
@property (strong,nonatomic)NSString *baseURL;
@property int index;

@end
