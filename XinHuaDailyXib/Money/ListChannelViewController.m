//
//  ListChannelViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import "ListChannelViewController.h"
#import "HomeCell.h"
#import "GlobalVariablesDefine.h"
#import "NavigationController.h"
#import "MJRefresh.h"
#import "ListFooterView.h"
#import "Reachability.h"
@interface ListChannelViewController ()
@property(nonatomic,strong)ChannelHeader *headerView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)ListFooterView *footerView;

@end

@implementation ListChannelViewController
@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)buildUI{
    if(lessiOS7){
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    }else{
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-20)];
    }
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.headerView=[[ChannelHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [ChannelHeader preferHeight])];
    self.headerView.article=self.articles_for_cvc.header_article;
    self.headerView.delegate=self;
    self.footerView=[[ListFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    self.footerView.delegate=self;
    [self.view addSubview:self.tableView];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadArticlesFromNET)];
}

#pragma mark - 表格视图数据源代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles_for_cvc.other_articles count];
}
NSString *ListCellID = @"ListCellID";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
    if(cell==nil){
        cell=[[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellID];
        cell.is_on_home=NO;
    }
    cell.article=[self.articles_for_cvc.other_articles objectAtIndex:(indexPath.row)];
    return (UITableViewCell *)cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HomeCell preferHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.articles_for_cvc.other_articles objectAtIndex:indexPath.row];
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
}
-(void)headerClicked:(Article *)article{
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
}
-(void)triggerRefresh{
    [self.tableView headerBeginRefreshing];
}
-(void)endRefresh{
    [self refreshUI];
    [self.tableView headerEndRefreshing];
}
-(void)refreshUI{
    if(self.articles_for_cvc.header_article!=nil){
        if(self.tableView.tableHeaderView==nil) self.tableView.tableHeaderView=[[ChannelHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [ChannelHeader preferHeight])];
        ((ChannelHeader *)self.tableView.tableHeaderView).article=self.articles_for_cvc.header_article;
        ((ChannelHeader *)self.tableView.tableHeaderView).delegate=self;
    }else{
        self.tableView.tableHeaderView=nil;
    }
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.is_full_load){
        [self removeLoadingFooter];
        return;
    }
    if(indexPath.row==[self.articles_for_cvc.other_articles count]-1){
        if([self.articles_for_cvc.other_articles count]>=10&&[self.articles_for_cvc.other_articles count]<50){
            [self beginLoadingMore];
        }else{
            [self endLoadingMore];
        }
    }
}
-(void)beginLoadingMore{
    self.tableView.tableFooterView = self.footerView;
    self.footerView.state=Busy;
    [self loadMoreArticlesFromNET];
}
-(void)endLoadingMore{
    self.tableView.tableFooterView = self.footerView;
    self.footerView.state=Idle;
}
-(void)removeLoadingFooter{
    self.tableView.tableFooterView = self.footerView;
    self.footerView.state=Hide;
}

-(void)touchViewClicked{
    [self beginLoadingMore];
}
@end
