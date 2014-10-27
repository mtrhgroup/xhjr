//
//  NewsBufferSettingViewController.m
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsBufferSettingViewController.h"
#import "NavigationController.h"
@interface NewsBufferSettingViewController ()
@property(nonatomic,assign)NSInteger currentIndex;
@end

@implementation NewsBufferSettingViewController
@synthesize currentIndex;
@synthesize table;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.title=@"保存条数";
     
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@",AppDelegate.user_defaults.font_size);
    if([AppDelegate.user_defaults.cache_article_number isEqualToString:@"10条"]){
        self.currentIndex=0;
    }else if([AppDelegate.user_defaults.cache_article_number isEqualToString:@"20条"]){
        self.currentIndex=1;
    }else if([AppDelegate.user_defaults.cache_article_number isEqualToString:@"50条"]){
        self.currentIndex=2;
    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)backAction:(id)sender{
   [self.navigationController popToRootViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    
    if ( cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"10条";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"20条";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"50条";
    }
    return cell;
}

#pragma mark - Table view delegate
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==self.currentIndex){
        return UITableViewCellAccessoryCheckmark;
    }
    else{
        return UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row==self.currentIndex){
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentIndex
                                                   inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.currentIndex=indexPath.row;
    if (indexPath.row == 0) {
        AppDelegate.user_defaults.cache_article_number = @"10条";
    }else if (indexPath.row == 1){
        AppDelegate.user_defaults.cache_article_number = @"20条";
    }else if (indexPath.row == 2){
        AppDelegate.user_defaults.cache_article_number = @"50条";
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *temp=@"保留条数";
    return temp;
}

@end
