//
//  woCenterViewController.h
//  TestSwipeView
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsManagerDelegate.h"
#import "NewsManager.h"
#import "NewsheaderDataSource.h"
#import "MainViewDataSource.h"
@interface woCenterViewController : UIViewController
@property(strong,nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic)NewsheaderDataSource *dataSource;
@property(strong,nonatomic)UILabel *titleLabel;
-(void)reloadTable;
-(void)setDataSourceAndLoadDataWith:(NewsheaderDataSource *)newDataSource;
-(void)setMainViewDataSourceAndLoadDataWith:(MainViewDataSource *)mainDataSource;
-(void)showExceptionNotification:(NSString *)statusInfo;
-(void)hideExceptionNotification;
@end
extern NSString *ShowLeftPanelNotification;
extern NSString *ShowRightPanelNotification;
