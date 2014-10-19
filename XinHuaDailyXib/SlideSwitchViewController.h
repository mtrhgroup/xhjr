
#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "DrawerViewController.h"
#import "ChannelViewController.h"
@interface SlideSwitchViewController : ChannelViewController<UINavigationControllerDelegate,SUNSlideSwitchViewDelegate>
-(void)rebuildUI;
@end
