//
//  DailyListViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "DailyListViewController.h"
#import "OtherDailyViewController.h"
#import "TileCell.h"
#import "DailyHeader.h"
#import "MJRefresh.h"
@interface DailyListViewController ()
@property(nonatomic, strong)DailyArticles *daily_articles;
@end

@implementation DailyListViewController
@synthesize service=_service;
@synthesize daily_articles=_daily_articles;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self fetchArticlesFromDB];
    [self.tableView addHeaderWithTarget:self action:@selector(fetchArticlesFromNET)];
}
-(void)fetchArticlesFromNET{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *time=[formatter stringFromDate:[NSDate distantFuture]];
//    [self.service fetchArticlesFromNETWithChannel:AppDelegate.channel time:time successHandler:^(NSArray *articles) {
//        self.daily_articles=[self.service fetchLatestDailyArticlesFromDBWithChannel:AppDelegate.channel];
//        super.tableView.tableHeaderView=[[DailyHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width,40)];
//        if(self.daily_articles.date.length==10){
//            ((DailyHeader *)self.tableView.tableHeaderView).date=self.daily_articles.date;
//        }
//        [super.tableView reloadData];
//        OtherDailyViewController *sub= [[OtherDailyViewController alloc] init];
//        sub.service=self.service;
//        sub.date=self.daily_articles.previous_date;
//        self.subTableViewController =sub;
//    } errorHandler:^(NSError *error) {
//        //
//    }];
}
-(void)fetchArticlesFromDB{
    self.daily_articles=[self.service fetchLatestDailyArticlesFromDBWithChannel:AppDelegate.channel];
    [super.tableView reloadData];
    OtherDailyViewController *sub= [[OtherDailyViewController alloc] init];
    sub.service=self.service;
    sub.date=self.daily_articles.previous_date;
    self.subTableViewController =sub;
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
    return 280;
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
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.daily_articles.articles objectAtIndex:indexPath.row];
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:AppDelegate.channel];
}
@end
