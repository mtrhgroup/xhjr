//
//  KidsAboutViewController.m
//  kidsgarden
//
//  Created by apple on 14/6/25.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "AboutViewController.h"
#import "NavigationController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"关于";
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-57, self.view.bounds.size.height/2-167, 114.0f, 114.0f)];
    logoView.image=[UIImage imageNamed:@"logo_114.png"];
    [self.view addSubview:logoView];
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-120, self.view.bounds.size.height/2-32, 240.0f, 64.0f)];
    titleView.image=[UIImage imageNamed:@"app_title.png"];
    [self.view addSubview:titleView];

    UILabel *service_phone=[[UILabel alloc]initWithFrame:CGRectMake(titleView.frame.origin.x, titleView.frame.origin.y+titleView.frame.size.height+40, 200, 30)];
    [service_phone setText:[NSString stringWithFormat:@"客服电话：%@",@"010-86888688"]];
    [self.view addSubview:service_phone];
    UILabel *copy_right=[[UILabel alloc]initWithFrame:CGRectMake(titleView.frame.origin.x, titleView.frame.origin.y+titleView.frame.size.height+70, 200, 50)];
    [copy_right setFont:[UIFont systemFontOfSize:12]];
    copy_right.textColor=[UIColor lightGrayColor];
    copy_right.numberOfLines=2;
    copy_right.textAlignment=NSTextAlignmentCenter;
    [copy_right setText:@"Copyright©2014 爱亲子工作室"];
    
    [self.view addSubview:copy_right];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
