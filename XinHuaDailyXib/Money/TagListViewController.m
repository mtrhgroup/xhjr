//
//  ListViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "TagListViewController.h"
#import "HomeCell.h"
#import "NavigationController.h"
#import "ArticleViewController.h"
#import "GlobalVariablesDefine.h"
@interface TagListViewController ()
@property(nonatomic, strong)NSArray *articles;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation TagListViewController
@synthesize tag=_tag;
@synthesize articles=_articles;
@synthesize service=_service;
@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.tag;
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
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_menu_default.png"] target:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
}
-(void)showLeftMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadArticlesFromDB];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadArticlesFromDB{
    self.articles=[self.service fetchArticlesFromDBWithTag:self.tag];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HomeCell preferHeight];
}
static NSString *TileCellID = @"cellname";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:TileCellID];
    if(cell==nil){
        cell=[[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TileCellID];
        cell.is_on_home=YES;
    }
    cell.article=[self.articles objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.articles objectAtIndex:indexPath.row];
    ArticleViewController *vc=[[ArticleViewController alloc] initWithAritcle:article];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
