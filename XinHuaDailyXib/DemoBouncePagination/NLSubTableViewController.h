//
//  NLSubTableViewController.h
//  NLScrollPagination
//
//  Created by noahlu on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLPullDownRefreshView.h"
#import "NLPullUpRefreshView.h"
@interface NLSubTableViewController : UITableViewController<NLPullUpRefreshViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) UITableViewController *mainTableViewController;
@property(nonatomic, strong)NLPullUpRefreshView *pullUpView;
@property(nonatomic, strong)NLPullDownRefreshView *pullDownView;
@property(nonatomic, strong)NLSubTableViewController *subTableViewController;
@property(nonatomic) BOOL isResponseToScroll;
- (void)addPullUpView;
- (void)addNextPage;
@end
