//
//  PushNewsViewController.h
//  XinHuaDailyXib
//
//  Created by 张健 on 14-3-7.
//
//

#import <UIKit/UIKit.h>

@interface PushNewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *articles;
@property (strong, nonatomic) UITableView *table;
@property (nonatomic,strong)UILabel *emptyinfo_label;
@end
extern NSString *PushPeriodicalNewsHeaderSelectionNotification;
extern NSString *PushExpressNewsHeaderSelectionNotification;
