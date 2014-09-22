//
//  woCenterViewController.m
//  TestSwipeView
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "woCenterViewController.h"
#import "NewsheaderDataSource.h"
#import "MainViewDataSource.h"
#import "NewsChannel.h"
#import "VersionInfo.h"
@implementation woCenterViewController{
    UIView *_notificationView;
    UILabel *_notificationLbl;
}
@synthesize refreshHeaderView=_refreshHeaderView;
@synthesize tableView=_tableView;
@synthesize dataSource=_dataSource;
@synthesize titleLabel=_titleLabel;
- (void) viewDidLayoutSubviews {
    // only works for iOS 7+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        // snaps the view under the status bar (iOS 6 style)
        viewBounds.origin.y = topBarOffset*-1;
        
        // shrink the bounds of your view to compensate for the offset
        //viewBounds.size.height = viewBounds.size.height -20;
        self.view.bounds = viewBounds;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitle) name:@"KVersionInfoOK" object:nil];    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden=YES;
    UIImageView* topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topView.userInteractionEnabled = YES;
#ifdef LNZW
    topView.image = [UIImage imageNamed:@"ext_navbar.png"];
#endif
#ifdef HNZW
    topView.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];;
#endif
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"version_info"];
    VersionInfo *version_info=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, -20, 320, 50)];
#ifdef LNZW
    bgView.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
#endif
#ifdef HNZW
    bgView.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
#endif
    [self.view addSubview:bgView];
#ifdef HNZW
    if(version_info.groupTitle!=nil){
    _titleLabel.text = version_info.groupSubTitle;
    }else{
       _titleLabel.text=@"海南舆情通";
    }
#endif
#ifdef LNZW
    if(version_info.groupTitle!=nil){
        _titleLabel.text = version_info.groupTitle;
    }else{
        _titleLabel.text=@"辽宁舆情通";
    }
#endif
    
    _titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:21];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
#ifdef HNZW
    _titleLabel.textColor = [UIColor whiteColor];
#endif
#ifdef LNZW
    _titleLabel.textColor = [UIColor blackColor];
#endif
    [topView addSubview:_titleLabel];
    [self.view addSubview:topView];
    
    UIButton* leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40,43)];
    UIImage *left_image=[UIImage imageNamed:@"ext_nav_columns.png"];
    [leftBtn setImage:left_image forState:UIControlStateNormal];
    [leftBtn  addTarget:self action:@selector(showLeftPanel) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    
    UIButton* rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(275, 0,43,43)];
    UIImage *right_image=[UIImage imageNamed:@"nav_func.png"];
    [rightBtn setImage:right_image forState:UIControlStateNormal];
    [rightBtn  addTarget:self action:@selector(showRightPanel) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    [self.view setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
    [self.tableView addSubview:self.refreshHeaderView];
    [self.view addSubview:self.tableView];
    
    
    [self setMainViewDataSource:AppDelegate.objectConfigration.mainViewDataSource];
    [self.dataSource reloadDataFromCoreData];
    [(MainViewDataSource *)self.dataSource simulatePullHeaderView];
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    _notificationView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 20)];
    _notificationView.backgroundColor=[UIColor yellowColor];
    _notificationView.alpha=0.618;
    _notificationLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    _notificationLbl.text = @"授权已过期!";
    _notificationLbl.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:10];
    _notificationLbl.textAlignment = NSTextAlignmentCenter;
    _notificationLbl.backgroundColor = [UIColor clearColor];
    _notificationLbl.textColor = [UIColor blackColor];
    _notificationView.hidden=YES;
    [_notificationView addSubview:_notificationLbl];
    [self.view addSubview:_notificationView];
}
-(void)updateTitle{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"version_info"];
    VersionInfo *version_info=[NSKeyedUnarchiver unarchiveObjectWithData:data];
#ifdef LNZW
    if(version_info.groupTitle!=nil){
        _titleLabel.text = version_info.groupTitle;
    }else{
        _titleLabel.text=@"辽宁舆情通";
    }
#endif
#ifdef HNZW
    if(version_info.groupTitle!=nil){
        _titleLabel.text = version_info.groupSubTitle;
    }else{
        _titleLabel.text=@"海南舆情通";
    }
#endif
}

-(void)showExceptionNotification:(NSString *)statusInfo{
    _notificationLbl.text=statusInfo;
    _notificationView.hidden=NO;
}
-(void)hideExceptionNotification{
    _notificationView.hidden=YES;
}
-(void)showLeftPanel{
    NSNotification *note=[NSNotification notificationWithName:ShowLeftPanelNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
-(void)showRightPanel{
    NSNotification *note=[NSNotification notificationWithName:ShowRightPanelNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
-(void)setDataSourceAndLoadDataWith:(NewsheaderDataSource*)newDataSource{
    [self setDataSource:newDataSource];
    _titleLabel.text=newDataSource.channel.title;
    self.tableView.frame=CGRectMake(5, 44, 315, 416+(iPhone5?88:0));
#ifdef LNZW
    [self.view setBackgroundColor:newDataSource.channel.color];
#endif
    [_dataSource reloadData];
}
-(void)setMainViewDataSourceAndLoadDataWith:(MainViewDataSource *)mainDataSource{
    [self setDataSource:mainDataSource];
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"version_info"];
    VersionInfo *version_info=[NSKeyedUnarchiver unarchiveObjectWithData:data];
#ifdef HNZW
    if(version_info==nil||version_info.groupTitle==nil){
        _titleLabel.text=@"新华时讯通";
    }else if(version_info.groupTitle!=nil){
         _titleLabel.text=[NSString stringWithFormat:@"%@",version_info.groupSubTitle] ;
    }
#endif
#ifdef LNZW
    if(version_info==nil||version_info.groupTitle==nil){
        _titleLabel.text=@"新华时讯通";
    }else if(version_info.groupTitle!=nil){
        _titleLabel.text=[NSString stringWithFormat:@"%@",version_info.groupTitle] ;
    }
#endif
    self.tableView.frame=CGRectMake(0, 44, 320, 416+(iPhone5?88:0));
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [_dataSource reloadData];
}
-(void)setDataSource:(NewsheaderDataSource*)newDataSource{
    if([_dataSource isEqual:newDataSource])return;
    _dataSource=newDataSource;
    _refreshHeaderView.delegate = _dataSource;
    _tableView.delegate =  _dataSource;
    _tableView.dataSource=_dataSource;
    _dataSource.tableview=_tableView;
    _dataSource.refreshheaderview=_refreshHeaderView;
    
}
-(void)setMainViewDataSource:(MainViewDataSource *)mainViewDataSource{
    if([_dataSource isEqual:mainViewDataSource])return;
    _dataSource=mainViewDataSource;
    _refreshHeaderView.delegate = _dataSource;
    _tableView.delegate =  _dataSource;
    _tableView.dataSource=_dataSource;
    _dataSource.tableview=_tableView;
    _dataSource.refreshheaderview=_refreshHeaderView;
}
-(void)reloadTable{
    [_dataSource reloadDataFromCoreData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
	//_refreshHeaderView=nil;
}
NSString *ShowLeftPanelNotification=@"ShowLeftPanelNotification";
NSString *ShowRightPanelNotification=@"ShowRightPanelNotification";
@end
