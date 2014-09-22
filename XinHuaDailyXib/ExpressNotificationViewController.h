//
//  ExpressViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressNotificationViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong,nonatomic)UIView *waitingView;
@property (strong,nonatomic)UIActivityIndicatorView *indicator;
@property (nonatomic,strong)UIControl *emptyinfo_view;
@property(nonatomic,strong) NSString * item_id;
@end
