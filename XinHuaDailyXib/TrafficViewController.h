//
//  KidsTrafficViewController.h
//  kidsgarden
//
//  Created by apple on 14/6/25.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,retain) UILabel *currentMonth3G;
@property (nonatomic,retain) UILabel *currentMonthWifi;
@property (nonatomic,retain) UILabel *lastMonth3G;
@property (nonatomic,retain) UILabel *lastMonthWifi;
@end
