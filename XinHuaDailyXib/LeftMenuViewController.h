
#import <UIKit/UIKit.h>
#import "HomeViewController.h"
@interface LeftMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)   UILabel*title_label;
@property (nonatomic,strong)   UILabel *sub_title_label;
@property(nonatomic,strong)HomeViewController *home_vc;
-(void)rebuildUI;
@end
