//
//  DemoSubViewController.m
//  NLScrollPagination
//
//  Created by noahlu on 14-8-11.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import "OtherDailyViewController.h"
#import "TileCell.h"
#import "DailyHeader.h"
#import "GlobalVariablesDefine.h"
@interface OtherDailyViewController ()
@property(nonatomic,strong)DailyArticles *previous_daily_articles;
@end

@implementation OtherDailyViewController
@synthesize service=_service;
@synthesize date=_date;
@synthesize daily_articles=_daily_articles;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self.view addSubview:self.tableView];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addPullDownView];
    self.view.backgroundColor = [UIColor clearColor];
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self.view addSubview:self.tableView];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addPullDownView];
    self.view.backgroundColor=VC_BG_COLOR;
    [self addPullUpView];
    self.subTableViewController=[[OtherDailyViewController alloc] init];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self loadThisDailyFromDB];
}
-(void)loadThisDailyFromNET{
    NSMutableString *time_mutable=[NSMutableString stringWithString:self.date];
    [time_mutable replaceOccurrencesOfString:@"-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [self.date length])];
    NSString *time=[time_mutable stringByAppendingString:@"000000"];
    [self.service fetchArticlesFromNETWithChannel:AppDelegate.channel time:time successHandler:^(NSArray *articles) {
        self.daily_articles=[self.service fetchDailyArticlesFromDBWithChannel:AppDelegate.channel date:self.date];
        super.tableView.tableHeaderView=[[DailyHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width,40)];
        if(self.daily_articles.date.length==10){
            ((DailyHeader *)self.tableView.tableHeaderView).date=self.daily_articles.date;
        }
        [super.tableView reloadData];
    } errorHandler:^(NSError *error) {
        //
    }];
}
-(void)loadThisDailyFromDB{
    self.daily_articles=[self.service fetchDailyArticlesFromDBWithChannel:AppDelegate.channel date:self.date];
    super.tableView.tableHeaderView=[[DailyHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width,40)];
    if(self.daily_articles.date.length==10){
        ((DailyHeader *)self.tableView.tableHeaderView).date=self.daily_articles.date;
    }
    [super.tableView reloadData];
    float originY = self.tableView.contentSize.height;
    self.pullUpView.frame=CGRectMake(0, originY, self.view.frame.size.width, 50.f);
}
-(void)loadPreviousDailyFromNET{
    NSMutableString *time_mutable=[NSMutableString stringWithString:self.daily_articles.previous_date];
    [time_mutable replaceOccurrencesOfString:@"-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [self.daily_articles.previous_date length])];
    NSString *time=[time_mutable stringByAppendingString:@"000000"];
    [self.service fetchArticlesFromNETWithChannel:AppDelegate.channel time:time successHandler:^(NSArray *articles) {
        self.previous_daily_articles=[self.service fetchDailyArticlesFromDBWithChannel:AppDelegate.channel date:self.daily_articles.previous_date];
        OtherDailyViewController *sub= [[OtherDailyViewController alloc] init];
        sub.service=self.service;
        sub.date=self.daily_articles.previous_date;
        sub.mainTableViewController=self;
        [sub loadThisDailyFromDB];
        self.subTableViewController =sub;
        [self addNextPage];
        [self changeUIForPullUp];
    } errorHandler:^(NSError *error) {
        self.previous_daily_articles=[self.service fetchDailyArticlesFromDBWithChannel:AppDelegate.channel date:self.daily_articles.previous_date];
        OtherDailyViewController *sub= [[OtherDailyViewController alloc] init];
        sub.service=self.service;
        sub.date=self.daily_articles.previous_date;
        sub.mainTableViewController=self;
        [sub loadThisDailyFromDB];
        self.subTableViewController =sub;
        [self addNextPage];
        [self changeUIForPullUp];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.daily_articles.articles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TileCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cellname"];
    if(cell==nil){
        cell=[[TileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellname"];
    }
    cell.article=[self.daily_articles.articles objectAtIndex:indexPath.row];
    return [cell preferHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TileCellID = @"cellname";
    TileCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:TileCellID];
    if(cell==nil){
        cell=[[TileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TileCellID];
    }
    cell.article=[self.daily_articles.articles objectAtIndex:indexPath.row];
    cell.type=None;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.daily_articles.articles objectAtIndex:indexPath.row];
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:AppDelegate.channel];
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
- (void)addPullDownView {
    if (self.pullDownView == nil) {
        self.pullDownView = [[NLPullDownRefreshView alloc]initWithFrame:CGRectMake(0, -50.f, self.view.frame.size.width, 50.f)];
        self.pullDownView.backgroundColor = [UIColor clearColor];
    }
    
    if (!self.pullDownView.superview) {
        [self.pullDownView setupWithOwner:self.tableView delegate:(id<NLPullDownRefreshViewDelegate>)self.mainTableViewController];
    }
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
    //self.pullUpView.hidden = NO;
    
}
- (void)pullUpRefreshDidFinish{
    if(self.daily_articles.previous_date.length!=0){
        if(self.subTableViewController!=nil&&[self.daily_articles.previous_date isEqualToString:((OtherDailyViewController *)self.subTableViewController).date]){
            self.pullUpView.hidden = YES;
            [self changeUIForPullUp];
        }else{
            [self loadPreviousDailyFromNET];
        }
    }else{
        [self.pullUpView stopLoading];
    }
}
- (void)changeUIForPullUp
{
    //    if (!self.refreshCounter) {
    //        self.refreshCounter = 0;
    //    }
    self.pullUpView.hidden = YES;
    // 上拉分页动画
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(-self.tableView.contentSize.height, 0, 0, 0);
        
    }];
    self.isResponseToScroll = NO;
    self.tableView.bounces = NO;
    [self.pullUpView stopLoading];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pullDownView scrollViewWillBeginDragging:scrollView];
    [self.pullUpView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullDownView scrollViewDidScroll:scrollView];
    [self.pullUpView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.pullDownView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [self.pullUpView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
