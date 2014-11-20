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
        [super pullUpRefreshDidFinish];
    } errorHandler:^(NSError *error) {
        self.previous_daily_articles=[self.service fetchDailyArticlesFromDBWithChannel:AppDelegate.channel date:self.daily_articles.previous_date];
        OtherDailyViewController *sub= [[OtherDailyViewController alloc] init];
        sub.service=self.service;
        sub.date=self.daily_articles.previous_date;
        sub.mainTableViewController=self;
        [sub loadThisDailyFromDB];
        self.subTableViewController =sub;
        [self addNextPage];
        [super pullUpRefreshDidFinish];
    }];
}
- (void)pullUpRefreshDidFinish{
    if(self.daily_articles.previous_date.length!=0){
        [self loadPreviousDailyFromNET];
    }else{
        [self.pullUpView startLoading];
    }
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
@end
