//
//  NewsArticleViewController.h
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
@interface NewsArticleViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *previousWebView;
@property (strong, nonatomic) UIWebView *nextWebView;
@property (strong, nonatomic) UIWebView *topWebView;
@property (strong,nonatomic)UIView *waitingView;
@property (strong,nonatomic)UIAlertView *waitingAlert;
@property (strong,nonatomic)UIView *bottonBar;
@property (strong,nonatomic)UIActivityIndicatorView *indicator;
@property(strong,nonatomic)UILabel *titleLabel;

@property (strong,nonatomic)NSMutableArray *siblings;
@property (strong,nonatomic)NSString *baseURL;
@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *channel_title;
@property (strong,nonatomic)NSString *item_title; 
@property int index;
- (void)swipeLeftAction:(id)sender;
- (void)swipeRightAction:(id)sender;
-(void)backAction:(id)sender;
@end
