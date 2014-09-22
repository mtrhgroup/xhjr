//
//  XdailyItemOlderViewControllerViewController.h
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsChannel.h"
@interface XdailyItemOlderViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong,nonatomic)UIView *waitingView;
@property (nonatomic,strong)UIView *emptyinfo_view;
@property (strong,nonatomic)UIActivityIndicatorView *indicator;

@property (strong,nonatomic)NSString *url;
@property (strong,nonatomic)NSString *outURL;
@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *channel_title;
@property (strong,nonatomic)NSString *channel_id;
@property(strong,nonatomic)NewsChannel *channel;
@end
