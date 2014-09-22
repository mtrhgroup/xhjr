//
//  NewsListPlusViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface NewsListPlusViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *previousWebView;
@property (strong, nonatomic) UIWebView *nextWebView;
@property (strong, nonatomic) UIWebView *topWebView;
@property (strong,nonatomic)UIView *waitingView;
@property (strong,nonatomic)UIActivityIndicatorView *indicator;


@property (strong,nonatomic)NSArray *siblings;
@property (strong,nonatomic)NSMutableArray *newslist;
@property (strong,nonatomic)NSString *baseURL;
@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *channel_title;
@property (strong,nonatomic)NSString *item_title;
@property int index;
- (void)swipeLeftAction:(id)sender;
- (void)swipeRightAction:(id)sender;
-(void)backAction:(id)sender;
@end
