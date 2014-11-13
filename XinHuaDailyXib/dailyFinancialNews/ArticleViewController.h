//
//  ArticleViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge_iOS.h"
#import "Service.h"
#import "WaitingView.h"
#import "PopupMenuView.h"
#import "ZSYPopoverListView.h"
#import "RefreshTouchView.h"
#import "ArticleViewDelegate.h"
@interface ArticleViewController : UIViewController<UIWebViewDelegate,FontAlertDelegate,TouchViewDelegate>
- (id)initWithAritcle:(Article *)article;
-(id)initWithPushArticleID:(NSString *)articleID;
@end
