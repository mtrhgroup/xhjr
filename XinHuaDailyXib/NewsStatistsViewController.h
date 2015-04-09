//
//  NewsStatistsViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  流量统计界面的ctrl

#import <UIKit/UIKit.h>
@interface NewsStatistsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView* table;
@property (nonatomic,retain) UILabel *currentMonth3G;
@property (nonatomic,retain) UILabel *currentMonthWifi;
@property (nonatomic,retain) UILabel *lastMonth3G;
@property (nonatomic,retain) UILabel *lastMonthWifi;
@end
