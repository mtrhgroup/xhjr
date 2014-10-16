//
//  KidsSettingViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/11.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "SettingViewController.h"
#import "TrafficViewController.h"
#import "AboutViewController.h"
#import "NavigationController.h"

@interface SettingViewController ()
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled=false;
    [self.view addSubview:_tableView];
[((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"title_menu_btn_normal.png"] target:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
  

}
-(void)showLeftMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *temp=@"";
    if(section==0){
        temp=@"班级管理";
    }else if(section==1){
        temp=@"流量统计";
    }else if(section==2){
        temp=@"其他";
    }
    return temp;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }else if(section==1){
        return 1;
    }else if(section==2){
        return 1;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* str = @"cellid";
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section==0){
        if (indexPath.row == 0){
            cell.textLabel.text = @"选择班级";
        }
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            cell.textLabel.text =  @"本月2G/3G流量";
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
            cell.textLabel.text =  @"关于";
        }
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1&&indexPath.row==0){
        TrafficViewController *traffic_vc=[[TrafficViewController alloc]init];
        UINavigationController  *nav_vc = [[NavigationController alloc] initWithRootViewController:traffic_vc];
        [self presentViewController:nav_vc animated:YES completion:nil];
    }else if(indexPath.section==2&&indexPath.row==0){
        AboutViewController *about_vc=[[AboutViewController alloc]init];
        UINavigationController  *nav_vc = [[NavigationController alloc] initWithRootViewController:about_vc];
        [self presentViewController:nav_vc animated:YES completion:nil];
    }

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}

-(void)didPresentAlertView:(UIAlertView *)alertView
{

}

-(void)willPresentAlertView:(UIAlertView *)alertView
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
