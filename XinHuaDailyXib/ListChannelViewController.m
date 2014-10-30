//
//  ListChannelViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import "ListChannelViewController.h"
#import "ListCell.h"
#import "GlobalVariablesDefine.h"
#import "NavigationController.h"
#import "MJRefresh.h"
@interface ListChannelViewController ()
@property(nonatomic,strong)ChannelHeader *headerView;
@property(nonatomic, strong) UITableView *tableView;

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
//    if([self.channel.parent_id isEqualToString:@"0"])
//        if(lessiOS7){
//            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-kHeightOfTopScrollView)];
//        }else{
//            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-20-kHeightOfTopScrollView)];
//        }
//    
//        else{
            if(lessiOS7){
                NSLog(@"%f",self.view.bounds.size.height);
                self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
            }else{
                self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            }
            
//        }
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.headerView=[[ChannelHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width*0.618)];
    self.headerView.article=self.articles_for_cvc.header_article;
    self.headerView.delegate=self;
    [self.view addSubview:self.tableView];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadArticlesFromNET)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreArticlesFromNET)];
}

#pragma mark - 表格视图数据源代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles_for_cvc.other_articles count];
}
NSString *ListCellID = @"ListCellID";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
    if(cell==nil){
        cell=[[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellID];
    }
    cell.article=[self.articles_for_cvc.other_articles objectAtIndex:(indexPath.row)];
    return (UITableViewCell *)cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
        if(self.tableView.tableHeaderView==nil) self.tableView.tableHeaderView=[[ChannelHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.view.bounds.size.width*0.618)];
        ((ChannelHeader *)self.tableView.tableHeaderView).article=self.articles_for_cvc.header_article;
        ((ChannelHeader *)self.tableView.tableHeaderView).delegate=self;
    }else{
        self.tableView.tableHeaderView=nil;
    }
    [self.tableView reloadData];
}

@end
