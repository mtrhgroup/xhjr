//
//  InstantContentViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 13-3-4.
//
//

#import <UIKit/UIKit.h>
#import "NewsManagerDelegate.h"
@interface InstantContentViewController : UIViewController<UIWebViewDelegate,NewsManagerDelegate>
-(void)loadWithXdaily:(XDailyItem *)item;
@end
