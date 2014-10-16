
#import <UIKit/UIKit.h>

@interface LeftMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)   UILabel*title_label;
@property (nonatomic,strong)   UILabel *sub_title_label;
-(void)rebuildUI;
@end
