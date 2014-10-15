
#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "ItemListViewController.h"
#import "DrawerViewController.h"

@interface SlideSwitchViewController : UIViewController<UINavigationControllerDelegate,SUNSlideSwitchViewDelegate>
-(void)rebuildUI;
@end
