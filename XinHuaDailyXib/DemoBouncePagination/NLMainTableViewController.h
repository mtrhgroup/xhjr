//
//  NLMainTableViewController.h
//  NLScrollPagination
//
//  Created by ; on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLSubTableViewController.h"
#import "NLPullUpRefreshView.h"

@interface NLMainTableViewController : UITableViewController<NLPullDownRefreshViewDelegate, NLPullUpRefreshViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)NLPullUpRefreshView *pullUpView;
@property(nonatomic, strong) NLSubTableViewController *subTableViewController;
@property(nonatomic) BOOL isResponseToScroll;
- (void)addPullUpView;
- (void)addNextPage;

@end
