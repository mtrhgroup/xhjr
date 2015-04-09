//
//  OnlineWebViewController.h
//  XinHuaDailyXib
//
//  Created by 张健 on 15-2-9.
//
//

#import <UIKit/UIKit.h>
#import "RefreshTouchView.h"
@interface OnlineWebViewController : UIViewController<UIWebViewDelegate,TouchViewDelegate>
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *top_name;
@end
