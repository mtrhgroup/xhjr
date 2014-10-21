//
//  TileChannelViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import "TileChannelViewController.h"
#import "GlobalVariablesDefine.h"
#import "NavigationController.h"
#import "MJRefresh.h"
#import "TileCell.h"
@interface TileChannelViewController ()
@property(nonatomic,strong)ChannelHeader *headerView;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation TileChannelViewController
@synthesize tableView=_tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)buildUI{
    if(![self.channel.parent_id isEqualToString:@"0"])
        if(lessiOS7){
            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-kHeightOfTopScrollView)];
        }else{
            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-20-kHeightOfTopScrollView)];
        }
    
        else{
            if(lessiOS7){
                NSLog(@"%f",self.view.bounds.size.height);
                self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
            }else{
                self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            }
        }
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.headerView=[[ChannelHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 160)];
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
NSString *TileCellID = @"TileCellID";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TileCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:TileCellID];
    if(cell==nil){
        cell=[[TileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TileCellID];
    }
    cell.article=[self.articles_for_cvc.other_articles objectAtIndex:(indexPath.row)];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.articles_for_cvc.other_articles objectAtIndex:indexPath.row];
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
}
-(void)headerClicked:(Article *)article{
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
}
-(void)triggerRefresh{
    [self reloadArticlesFromNET];
}
-(void)refreshUI{
    if(self.articles_for_cvc.header_article!=nil){
        if(self.tableView.tableHeaderView==nil) self.tableView.tableHeaderView=[[ChannelHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 160)];
        ((ChannelHeader *)self.tableView.tableHeaderView).article=self.articles_for_cvc.header_article;
        ((ChannelHeader *)self.tableView.tableHeaderView).delegate=self;
    }else{
        self.tableView.tableHeaderView=nil;
    }
    [self.tableView reloadData];
}
@end
