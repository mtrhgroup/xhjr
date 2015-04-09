//
//  ExpressViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressNotificationViewController : UIViewController<UIWebViewDelegate>
@property (retain, nonatomic) UIWebView *webView;
@property (retain,nonatomic)UIView *waitingView;
@property (retain,nonatomic)UIActivityIndicatorView *indicator;
@property (nonatomic,retain)UIView *emptyinfo_view;
@property(nonatomic,copy) NSString * item_id;
@end
