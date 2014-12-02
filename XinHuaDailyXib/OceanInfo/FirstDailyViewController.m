//
//  DailyListViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "FirstDailyViewController.h"
#import "OtherDailyViewController.h"
#import "ArticleViewController.h"
#import "TileCell.h"
#import "DailyHeader.h"
#import "MJRefresh.h"
#import "NavigationController.h"
#import "GlobalVariablesDefine.h"
@interface FirstDailyViewController ()
@property(nonatomic, strong)DailyArticles *daily_articles;
@property(nonatomic,strong)DailyArticles *previous_daily_articles;
@end

@implementation FirstDailyViewController
@synthesize service=_service;
@synthesize daily_articles=_daily_articles;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=VC_BG_COLOR;
    self.tableView.backgroundColor=VC_BG_COLOR;
    [self.tableView addHeaderWithTarget:self action:@selector(loadThisDailyFromNET)];
    [self addPullUpView];
    UIImageView *title_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_top_subject.png"]];
    title_view.frame=CGRectMake((self.view.bounds.size.width-100)/2, 2, 100, 40);
    [self.navigationController.navigationBar addSubview:title_view];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_menu_selected.png"] target:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"button_set_default.png"] target:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadThisDailyFromDB) name:kNotificationLatestDailyReceived object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadThisDailyFromDB];


}
-(void)showLeft{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)showRight{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
-(void)loadThisDailyFromNET{
    [self.service fetchLatestArticlesFromNETWithChannel:AppDelegate.channel successHandler:^(NSArray *articles) {
        [self reloadThisDailyFromDB];
        [self.tableView headerEndRefreshing];
    } errorHandler:^(NSError *error) {
        [self reloadThisDailyFromDB];
        [self.tableView headerEndRefreshing];
    }];
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
    [self.tableView headerEndRefreshing];
    if(self.daily_articles.previous_date.length!=0){
//        if(self.subTableViewController!=nil&&[self.daily_articles.previous_date isEqualToString:((OtherDailyViewController *)self.subTableViewController).date]){
//            [super pullUpRefreshDidFinish];
//        }else{
//           [self loadPreviousDailyFromNET];
//        }
         [self loadPreviousDailyFromNET];
    }else{
        [self.pullUpView startLoading];
    }
    
}
-(void)reloadThisDailyFromDB{
    self.daily_articles=[self.service fetchLatestDailyArticlesFromDBWithChannel:AppDelegate.channel];
    super.tableView.tableHeaderView=[[DailyHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width,40)];
    if(self.daily_articles.date.length==10){
        ((DailyHeader *)self.tableView.tableHeaderView).date=self.daily_articles.date;
    }
    [super.tableView reloadData];
    float originY = self.tableView.contentSize.height;
    NSLog(@"originY = %f",originY);
    self.pullUpView.frame=CGRectMake(0, originY, self.view.frame.size.width, 50.f);
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
    cell = [tableView dequeueReusableCellWithIdentifier:TileCellID];
    if(cell==nil){
        cell=[[TileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TileCellID];
    }
    cell.article=[self.daily_articles.articles objectAtIndex:indexPath.row];
    return [cell preferHeight];
}
static NSString *TileCellID = @"cellname";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TileCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:TileCellID];
    if(cell==nil){
        cell=[[TileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TileCellID];
    }
    cell.type=Wraped_Date;
    cell.article=[self.daily_articles.articles objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.daily_articles.articles objectAtIndex:indexPath.row];
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:AppDelegate.channel];
}
@end
