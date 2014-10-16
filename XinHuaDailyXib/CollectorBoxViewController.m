//
//  KidsFavorViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/27.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "CollectorBoxViewController.h"
#import "ArticleViewController.h"
#import "FavorCell.h"
#import "NavigationController.h"
@interface CollectorBoxViewController ()

@end

@implementation CollectorBoxViewController
@synthesize items=_items;
    
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _service=AppDelegate.service;
        _items=[[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [self reloadDataFromDB];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    // Do any additional setup after loading the view.
}
- (void)setupTableView
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"title_menu_btn_normal.png"] target:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
}
-(void)reloadDataFromDB{
    [_items removeAllObjects];
    [_items addObjectsFromArray:[self.service fetchFavorArticlesFromDB]];
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showLeftMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *favorCellID=@"favorCellID";
    FavorCell *cell = [tableView dequeueReusableCellWithIdentifier:favorCellID];
    if(!cell){
        cell=[[FavorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:favorCellID];
    }
    [cell setArticle:[_items objectAtIndex:indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.items objectAtIndex:indexPath.row];
    ArticleViewController *controller=[[ArticleViewController alloc] initWithAritcle:article];
    UINavigationController  *nav_vc = [[NavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav_vc animated:YES completion:nil];
}
@end
