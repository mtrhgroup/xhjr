//
//  woRightViewController.m
//  TestSwipeView
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "woRightViewController.h"
#import "FunctionSource.h"


#define BG_COLOR	 [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0]
#define HEADER_COLOR	 [UIColor colorWithRed:88.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0]

@interface woRightViewController ()

@end

@implementation woRightViewController{
    UITableView *_tableView;
    FunctionSource *_dataSource;
    UIView *_bottomView;
}

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
    
    
   
    
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0, 220, 460+(iPhone5?88:0))];
    CGSize newSize = CGSizeMake(220,460);
    [scrollView setContentSize:newSize];
    scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:scrollView];
    UIImageView* topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 65)];
    topView.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:topView];
    NSString* authcode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 12, 220, 40)];
    label.text = [NSString stringWithFormat:@"授权码：%@",authcode];
    label.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    [topView addSubview:label];
    _dataSource=[[FunctionSource alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 220, 330)];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.delegate =  _dataSource;
    _tableView.dataSource = _dataSource;
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
    self.view.backgroundColor=[UIColor whiteColor];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
