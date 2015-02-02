//
//  DailyViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/17.
//
//

#import "DailyViewController.h"
#import "TileCell.h"
#import "DailyHeader.h"
#import "NavigationController.h"
#import "ArticleViewController.h"
@interface DailyViewController ()
@property(nonatomic,strong)Service *service;
@property(nonatomic, strong)DailyArticles *daily_articles;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *date;
@end

@implementation DailyViewController
@synthesize service=_service;
@synthesize daily_articles=_daily_articles;
@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    if(lessiOS7){
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    }else{
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-20)];
    }
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadArticles];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithService:(Service *)service date:(NSString *)date{
        self = [super init];
        if (self) {
            self.service=service;
            self.date=date;
        }
        return self;
}
-(void)reloadArticles{
    if([self reloadArticlesFromDB]){
        self.tableView.tableHeaderView=[[DailyHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width,40)];
        if(self.daily_articles.date.length==10){
            ((DailyHeader *)self.tableView.tableHeaderView).date=self.daily_articles.date;
        }
        [self.tableView reloadData];
    }else{
        [self reloadArticlesFromNET];
    }
}
-(void)reloadArticlesFromNET{
    NSString *date_without_dash=[self.date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self.service fetchDailyArticlesFromNETWithChannel:AppDelegate.channel date:date_without_dash successHandler:^(NSArray *articles) {
        self.daily_articles=[self.service fetchDailyArticlesFromDBWithChannel:AppDelegate.channel date:self.date];
        self.tableView.tableHeaderView=[[DailyHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width,40)];
        if(self.daily_articles.date.length==10){
            ((DailyHeader *)self.tableView.tableHeaderView).date=self.daily_articles.date;
        }
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
       // <#code#>
    }];
}
-(BOOL)reloadArticlesFromDB{
    self.daily_articles=[self.service fetchDailyArticlesFromDBWithChannel:AppDelegate.channel date:self.date];
    if([self.daily_articles.articles count]==6){
        return YES;
    }else{
        return NO;
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
    cell.type=None;
    cell.article=[self.daily_articles.articles objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.daily_articles.articles objectAtIndex:indexPath.row];
    ArticleViewController *vc=[[ArticleViewController alloc] initWithAritcle:article];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
