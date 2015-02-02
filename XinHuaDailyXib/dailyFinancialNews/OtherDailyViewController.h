//
//  DemoSubViewController.h
//  NLScrollPagination
//
//  Created by noahlu on 14-8-11.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import "NLPullDownRefreshView.h"
#import "NLPullUpRefreshView.h"
@interface OtherDailyViewController :  UITableViewController<NLPullUpRefreshViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)NSString *date;
@property(nonatomic, strong)DailyArticles *daily_articles;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) UITableViewController *mainTableViewController;
@property(nonatomic, strong)NLPullUpRefreshView *pullUpView;
@property(nonatomic, strong)NLPullDownRefreshView *pullDownView;
@property(nonatomic, strong)OtherDailyViewController *subTableViewController;
@property(nonatomic) BOOL isResponseToScroll;
- (void)addPullUpView;
- (void)addNextPage;
-(void)loadThisDailyFromDB;
@end
