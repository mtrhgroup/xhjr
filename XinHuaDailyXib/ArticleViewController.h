//
//  KidsContentViewController.h
//  kidsgarden
//
//  Created by apple on 14/6/10.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "Service.h"
#import "WaitingView.h"
#import "PopupMenuView.h"
#import "ZSYPopoverListView.h"
#import "TouchRefreshView.h"
#import "ArticleViewDelegate.h"
@interface ArticleViewController : UIViewController<UIWebViewDelegate,PopupMenuDelegate,FontAlertDelegate,TouchViewDelegate,ArticleViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)WaitingView *waitingView;
@property(nonatomic,strong)TouchRefreshView *touchView;
@property(nonatomic,strong)PopupMenuView *popupMenuView;
@property(nonatomic,strong)ZSYPopoverListView *fontAlertView;

@property(nonatomic,assign)BOOL isAD;
- (id)initWithAritcle:(Article *)article;
-(id)initWithPushArticleID:(NSString *)articleID;
@end
