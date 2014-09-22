//
//  AdvPageViewController.h
//  XinHuaDailyXib
//
//  Created by 张健 on 14-3-7.
//
//

#import <UIKit/UIKit.h>

@interface AdvPageViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic,strong)UIControl *emptyinfo_view;
@end
