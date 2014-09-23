//
//  PeriodicalContentViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 13-3-4.
//
//

#import <UIKit/UIKit.h>
#import "NewsManagerDelegate.h"
@interface PeriodicalContentViewController : UIViewController<UIWebViewDelegate,NewsManagerDelegate>
-(void)loadWithXdaily:(XDailyItem *)item;
@end
