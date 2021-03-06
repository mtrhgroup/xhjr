//
//  NLMainTableViewController.m
//  NLScrollPagination
//
//  Created by noahlu on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import "NLMainTableViewController.h"
#import "NLPullUpRefreshView.h"

@interface NLMainTableViewController ()


@property(nonatomic) NSInteger refreshCounter;

@end

@implementation NLMainTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    
    self.view.backgroundColor = [UIColor clearColor];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self.view addSubview:self.tableView];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.isResponseToScroll = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self addRefreshView];
//    [self addNextPage];
    
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + 100.f);
}

- (void)addPullUpView {
    if (self.pullUpView == nil) {
        float originY = self.tableView.contentSize.height;
        NSLog(@"originY = %f",originY);
        self.pullUpView = [[NLPullUpRefreshView alloc]initWithFrame:CGRectMake(0, originY, self.view.frame.size.width, 50.f)];
        self.pullUpView.backgroundColor = [UIColor clearColor];
    }
    
    if (!self.pullUpView.superview) {
        [self.pullUpView setupWithOwner:self.tableView delegate:self];
    }
}

- (void)addNextPage
{
    if (!self.subTableViewController) {
        return;
    }
    
    self.subTableViewController.mainTableViewController = self;
    self.subTableViewController.tableView.frame = CGRectMake(0, self.tableView.contentSize.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.tableView addSubview:self.subTableViewController.tableView];
}



- (void)pullUpRefreshDidFinish
{
    if (!self.refreshCounter) {
        self.refreshCounter = 0;
    }
    
    // 上拉分页动画
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(-self.tableView.contentSize.height, 0, 0, 0);
        
    }];
    self.isResponseToScroll = NO;
    self.tableView.bounces = NO;
    [self.pullUpView stopLoading];
    self.pullUpView.hidden = YES;
}

- (void)pullDownRefreshDidFinish
{
    [self.subTableViewController.pullDownView stopLoading];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // maintable重绘之后，contentsize要重新加上offset
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height);
    }];
   // self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + 100.f);
    self.tableView.contentOffset=CGPointMake(self.tableView.contentOffset.x, 0);
    self.tableView.bounces = YES;
    self.isResponseToScroll = YES;
    self.pullUpView.hidden = NO;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isResponseToScroll) {
        [self.pullUpView scrollViewWillBeginDragging:scrollView];
    } else {
        [self.subTableViewController.pullDownView scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isResponseToScroll) {
        [self.pullUpView scrollViewDidScroll:scrollView];
    } else {
        [self.subTableViewController.pullDownView scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.isResponseToScroll) {
        [self.pullUpView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    } else {
        [self.subTableViewController.pullDownView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isResponseToScroll) {
        [self.pullUpView scrollViewDidEndDecelerating:scrollView];
    } else {
    }
}

@end
