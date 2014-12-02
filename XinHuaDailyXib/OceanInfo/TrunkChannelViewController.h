
#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "ChannelViewController.h"
@interface TrunkChannelViewController : ChannelViewController<UINavigationControllerDelegate,SUNSlideSwitchViewDelegate>
-(void)rebuildUI;
@end
