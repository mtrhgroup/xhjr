//
//  KidsContentViewController.h
//  kidsgarden
//
//  Created by apple on 14/6/10.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge_iOS.h"
#import "Service.h"
#import "WaitingView.h"
#import "PopupMenuView.h"
#import "ZSYPopoverListView.h"
#import "RefreshTouchView.h"
#import "ArticleViewDelegate.h"
#import "MWPhotoBrowser.h"
typedef NS_ENUM(NSInteger, PresentType)
{
    Present = 0,
    Push = 1,
};
@interface ArticleViewController : UIViewController<UIWebViewDelegate,FontAlertDelegate,TouchViewDelegate,UITextViewDelegate,MWPhotoBrowserDelegate>
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)Article *article;
@property(nonatomic,strong)NSString *channel_name;
- (id)initWithAritcle:(Article *)article;
-(id)initWithPushArticleID:(NSString *)articleID;
@end
