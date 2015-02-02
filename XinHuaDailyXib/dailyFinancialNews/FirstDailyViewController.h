//
//  DailyListViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>
#import "NLMainTableViewController.h"
#import "OtherDailyViewController.h"
#import "TipTouchView.h"
@interface FirstDailyViewController :UITableViewController<NLPullDownRefreshViewDelegate, NLPullUpRefreshViewDelegate,UITableViewDataSource, UITableViewDelegate,TipTouchViewDelegate>
@property(nonatomic,strong)Service *service;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)NLPullUpRefreshView *pullUpView;
@property(nonatomic, strong)OtherDailyViewController *subTableViewController;
@property(nonatomic) BOOL isResponseToScroll;
- (void)addPullUpView;
- (void)addNextPage;
@end
