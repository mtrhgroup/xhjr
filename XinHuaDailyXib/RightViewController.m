//
//  woRightViewController.m
//  TestSwipeView
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "RightViewController.h"
#import "AboutViewController.h"
#import "SettingViewController.h"
#import "CollectorBoxViewController.h"
#import "PushNewsViewController.h"
#import "NavigationController.h"

#define BG_COLOR	 [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0]
#define HEADER_COLOR	 [UIColor colorWithRed:88.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0]

@interface RightViewController ()
@property(nonatomic,strong)UILabel *sn_lbl;
@end

@implementation RightViewController{
    UITableView *_tableView;
    UIView *_bottomView;
}
@synthesize sn_lbl=_sn_lbl;

-(void)viewWillAppear:(BOOL)animated{
    if(AppDelegate.user_defaults.sn.length==0){
        _sn_lbl.hidden=YES;
    }else{
        _sn_lbl.text=[NSString stringWithFormat:@"授权码：%@",AppDelegate.user_defaults.sn];
        _sn_lbl.hidden=NO;
    }
}
-(void)showSN{
    _sn_lbl.text=[NSString stringWithFormat:@"授权码：%@",AppDelegate.user_defaults.sn];
    _sn_lbl.hidden=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = YES;
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(30, 0, 220, 460+(iPhone5?88:0))];
    CGSize newSize = CGSizeMake(220,460);
    [scrollView setContentSize:newSize];
    scrollView.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:(51.0/255.0) alpha:1.0];
    [self.view addSubview:scrollView];
    UIImageView* topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 65)];
    topView.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:(51.0/255.0) alpha:1.0];
    [scrollView addSubview:topView];
    _sn_lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 12, 220, 40)];
    _sn_lbl.text = @"";
    _sn_lbl.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
    _sn_lbl.textAlignment = NSTextAlignmentCenter;
    _sn_lbl.backgroundColor = [UIColor clearColor];
    _sn_lbl.textColor = [UIColor grayColor];
    [topView addSubview:_sn_lbl];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 220, 330)];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.delegate =  self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled=NO;
    [scrollView addSubview:_tableView];

    _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 460-150-65+(iPhone5?88:0), 220, 150+65)];
#ifdef HNZW
    UIImageView *dim2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Apple_Download.png"]];
    dim2.frame=CGRectMake(35, 0, 150, 150);
    [_bottomView addSubview:dim2];
#endif
    _bottomView.backgroundColor=[UIColor clearColor];

    UILabel *copyrightLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 150+12, 220, 40)];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int year=[comps year];
    copyrightLbl.text = [NSString stringWithFormat:@"Copyright © %d 新华社经济信息编辑部\nAll Rights Reserved",year];
    copyrightLbl.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:10];
    copyrightLbl.textAlignment =NSTextAlignmentCenter;
    copyrightLbl.numberOfLines=2;
    copyrightLbl.backgroundColor = [UIColor clearColor];
    copyrightLbl.textColor = [UIColor grayColor];
    [_bottomView addSubview:copyrightLbl];
    [scrollView addSubview:_bottomView];
    self.view.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:(51.0/255.0) alpha:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSN) name:kNotificationBindSNSuccess object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBindSNSuccess object:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* str = @"cellid";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    NSArray *views = [[cell contentView] subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17.0];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellAccessoryNone;
    if (indexPath.row == 0){
        UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 60,60)];
        UIImage *favor_image=[UIImage imageNamed:@"favor.png"];
        [favorBtn setImage:favor_image forState:UIControlStateNormal];
        favorBtn.showsTouchWhenHighlighted=YES;
        [favorBtn  addTarget:self action:@selector(showFavors) forControlEvents:UIControlEventTouchUpInside];
        [[cell contentView] addSubview:favorBtn];
        
        UILabel *FavorLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 80, 25)];
        FavorLbl.text=@"我的收藏";
        FavorLbl.textColor = [UIColor lightGrayColor];
        FavorLbl.font = [UIFont fontWithName:@"System" size:17];
        FavorLbl.textAlignment=NSTextAlignmentCenter;
        FavorLbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:FavorLbl];
        
        UIButton* settingsBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 15, 60,60)];
        UIImage *settings_image=[UIImage imageNamed:@"settings.png"];
        [settingsBtn setImage:settings_image forState:UIControlStateNormal];
        settingsBtn.showsTouchWhenHighlighted=YES;
        [settingsBtn  addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
        [[cell contentView] addSubview:settingsBtn];
        
        UILabel *SettingsLbl = [[UILabel alloc] initWithFrame:CGRectMake(120, 75, 80, 25)];
        SettingsLbl.text=@"管理设置";
        SettingsLbl.textAlignment=NSTextAlignmentCenter;
        SettingsLbl.textColor = [UIColor lightGrayColor];
        SettingsLbl.font = [UIFont fontWithName:@"System" size:17];
        SettingsLbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:SettingsLbl];
        
    }else if(indexPath.row == 1){
        UIButton* feedbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 60,60)];
        UIImage *feedback_image=[UIImage imageNamed:@"ext_feedback.png"];
        [feedbackBtn setImage:feedback_image forState:UIControlStateNormal];
        feedbackBtn.showsTouchWhenHighlighted=YES;
        [feedbackBtn  addTarget:self action:@selector(showPushNews) forControlEvents:UIControlEventTouchUpInside];
        [[cell contentView] addSubview:feedbackBtn];
        
        UILabel *feedbackLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 80, 25)];
        feedbackLbl.text=@"消息汇总";
        feedbackLbl.textAlignment=NSTextAlignmentCenter;
        feedbackLbl.textColor = [UIColor lightGrayColor];
        feedbackLbl.font = [UIFont fontWithName:@"System" size:17];
        feedbackLbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:feedbackLbl];
        
        UIButton* aboutBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 15, 60,60)];
        UIImage *about_image=[UIImage imageNamed:@"about.png"];
        [aboutBtn setImage:about_image forState:UIControlStateNormal];
        aboutBtn.showsTouchWhenHighlighted=YES;
        [aboutBtn  addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
        [[cell contentView] addSubview:aboutBtn];
        
        UILabel *aboutLbl = [[UILabel alloc] initWithFrame:CGRectMake(120, 75, 80, 25)];
        aboutLbl.text=@"客服电话";
        aboutLbl.textAlignment=NSTextAlignmentCenter;
        aboutLbl.textColor = [UIColor lightGrayColor];
        aboutLbl.font = [UIFont fontWithName:@"System" size:17];
        aboutLbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:aboutLbl];
    }else if(indexPath.row==2){
    }
    return cell;
}
-(void)showFavors{
    CollectorBoxViewController *vc=[[CollectorBoxViewController alloc]init];
    NavigationController *nv=[[NavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:nil];
}
-(void)showPushNews{
    PushNewsViewController *vc=[[PushNewsViewController alloc]init];
    NavigationController *nv=[[NavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:nil];
    
}
-(void)showSettings{
    SettingViewController *vc=[[SettingViewController alloc]init];
    NavigationController *nv=[[NavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:nil];
}
-(void)showAbout{
    AboutViewController *vc=[[AboutViewController alloc]init];
    NavigationController *nv=[[NavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:nil];
}

@end
