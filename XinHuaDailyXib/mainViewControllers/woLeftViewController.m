//
//  woLeftViewController.m
//  TestSwipeView
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "woLeftViewController.h"
#import "VersionInfo.h"
#import "ObjectConfigration.h"
#define BG_COLOR	 [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0]
#define HEADER_COLOR	 [UIColor colorWithRed:88.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0]
@interface woLeftViewController ()

@end

@implementation woLeftViewController{
    ChannelDataSource *_channelSource;
    NewsManager *_manager;
    UIView *_bottomView;
    UILabel *title;
    UILabel *subTitle;
}
@synthesize channelTableView=_channelTableView;
@synthesize dataSource=_dataSource;
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitle) name:@"KVersionInfoOK" object:nil];
    _channelTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 220, 460+(iPhone5?88:0))];
    //[_channelTableView setScrollEnabled:NO];
    _channelTableView.showsVerticalScrollIndicator=NO;
    _channelTableView.backgroundColor=[UIColor whiteColor];
    _channelTableView.separatorColor=[UIColor lightGrayColor];
    [self.view addSubview:_channelTableView];
	_manager=[[NewsManager alloc]init];
    _manager.delegate=self;
    [self setChannelSource:AppDelegate.objectConfigration.channelDataSource];
    [self reloadChannels];
    
    UIImageView* topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 65)];
    topView.backgroundColor=[UIColor whiteColor];
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"version_info"];
    VersionInfo *version_info=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(version_info==nil||version_info.groupTitle==nil){
        title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 40)];
#ifdef HNZW
        title.text = @"海南舆情通";
#endif
#ifdef LNZW
        title.text = @"辽宁舆情通";
#endif
        title.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:24];
        title.textAlignment = NSTextAlignmentLeft;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor blackColor];
        [topView addSubview:title];
        subTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 240, 40)];
        subTitle.text = @"";
        subTitle.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        subTitle.textAlignment = NSTextAlignmentLeft;
        subTitle.backgroundColor = [UIColor clearColor];
        subTitle.textColor = [UIColor grayColor];
        [topView addSubview:subTitle];
    }else if(version_info.groupSubTitle==nil){
        title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 40)];
        title.text = version_info.groupTitle;
        title.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:24];
        title.textAlignment = NSTextAlignmentLeft;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor blackColor];
        [topView addSubview:title];
        subTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 240, 40)];
        subTitle.text = @"";
        subTitle.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        subTitle.textAlignment = NSTextAlignmentLeft;
        subTitle.backgroundColor = [UIColor clearColor];
        subTitle.textColor = [UIColor grayColor];
        [topView addSubview:subTitle];
    }else{
        title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 40)];
        title.text = version_info.groupTitle;
        title.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:24];
        title.textAlignment = NSTextAlignmentLeft;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor blackColor];
        subTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 240, 40)];
        subTitle.text = version_info.groupSubTitle;
        subTitle.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        subTitle.textAlignment = NSTextAlignmentLeft;
        subTitle.backgroundColor = [UIColor clearColor];
        subTitle.textColor = [UIColor grayColor];
        [topView addSubview:title];
        [topView addSubview:subTitle];
    }
    _channelTableView.tableHeaderView=topView;
    _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220+(iPhone5?88:0), 65)];
    _bottomView.backgroundColor=[UIColor whiteColor];
    _channelTableView.tableFooterView=_bottomView;
    self.view.backgroundColor=[UIColor whiteColor];
}
-(void)updateTitle{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"version_info"];
    VersionInfo *version_info=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(version_info==nil||version_info.groupTitle==nil){
#ifdef HNZW
        title.text = @"海南舆情通";
#endif
#ifdef LNZW
        title.text = @"辽宁舆情通";
#endif
    }else if(version_info.groupSubTitle==nil){
      title.text = version_info.groupTitle;
    }else{
      title.text = version_info.groupTitle;
      subTitle.text = version_info.groupSubTitle;
    }
}
-(void)reloadChannels{
    [_manager fetchAllChannels];
}
-(void)setChannelSource:(ChannelDataSource *)channelSource{
    _channelSource=channelSource;
    _channelTableView.delegate=_channelSource;
    _channelTableView.dataSource=_channelSource;
}


#pragma mark - NewsManagerDelegate

- (void)didReceiveNewsHeaders:(NSArray *)items{
    [self performSelectorOnMainThread:@selector(updateUIWithNews:) withObject:items waitUntilDone:YES];
}

-(void)updateUIWithNews:(NSMutableArray *)items{
    _channelSource.items=items;
//    _channelTableView.frame=CGRectMake(0,0, self.view.frame.size.width, [[_channelSource getItems] count]*44);
//    _bottomView.frame=CGRectMake(0,65+[items count]*44+44,self.view.frame.size.width,65);
    [_channelTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
