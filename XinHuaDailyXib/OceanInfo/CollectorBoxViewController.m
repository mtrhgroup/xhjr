//
//  KidsFavorViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/27.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "CollectorBoxViewController.h"
#import "ArticleViewController.h"
#import "CollectorCell.h"
#import "NavigationController.h"
@interface CollectorBoxViewController ()
@property(nonatomic,strong)UIButton *mode_btn;
@property(nonatomic,assign)BOOL is_editable;
@end

@implementation CollectorBoxViewController
@synthesize items=_items;
@synthesize mode_btn=_mode_btn;
@synthesize is_editable=_is_editable;
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
    self.is_editable=NO;
    [self setupTableView];
    // Do any additional setup after loading the view.
}
- (void)setupTableView
{
    self.title=@"我的收藏";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.mode_btn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,50,30)];
    [self.mode_btn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.mode_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.mode_btn addTarget:self action:@selector(toggleToEditMode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if(lessiOS7){
        negativeSpacer.width=0;
    }else{
        negativeSpacer.width=-20;
    }
    negativeSpacer.width=0;
    UIBarButtonItem *right_btn_item=[[UIBarButtonItem alloc] initWithCustomView:self.mode_btn];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,right_btn_item,nil] animated:YES];
}
-(void)toggleToEditMode{
    self.is_editable=!self.is_editable;
    if(_is_editable){
        [self.mode_btn setTitle:@"完成" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }else{
        [self.mode_btn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)reloadDataFromDB{

    _items=[NSMutableArray arrayWithArray:[self.service fetchFavorArticlesFromDB]];
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning{
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
     CollectorCell*cell = [tableView dequeueReusableCellWithIdentifier:favorCellID];
    if(!cell){
        cell=[[CollectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:favorCellID];
    }
    [cell setArticle:[_items objectAtIndex:indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.items objectAtIndex:indexPath.row];
        ArticleViewController *controller=[[ArticleViewController alloc] initWithAritcle:article];
        UINavigationController  *nav_vc = [[NavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav_vc animated:YES completion:nil];
}
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
         Article * article = [self.items objectAtIndex:indexPath.row];
        [self.items removeObjectAtIndex:indexPath.row];
        [self.service  markArticleCollectedWithArticle:article is_collected:NO];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
@end
