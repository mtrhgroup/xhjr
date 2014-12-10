//
//  MainViewController.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/15.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#define VIEWCONTROLLERWIDTH 280
#define VIEWCONTROLLERHEIGHT self.view.frame.size.height
#define TABLEVIEWTAG 50
#define BUTTONTAG 100
//请求数据个数
//#define DATACOUNT @"10"
#define LINECOLOR @"#ececec"

#import "OrderViewController.h"
#import "HotForecastModel.h"
#import "UIColor+Hex.h"
#import "NSString+Addtions.h"
#import "NSString+SBJSON.h"
#import "YourSayViewController.h"
#import "XHRequest.h"

#import "HotForecastTableView.h"
#import "AttentionTableView.h"
#import "EveryoneChooseTableView.h"
#import "MyChooseView.h"

@interface OrderViewController ()<UIScrollViewDelegate,ASIHTTPRequestDelegate>
@end

@implementation OrderViewController
{
    UIView * _backGroundView;
    // 头条 推荐 娱乐 体育。。。
    UIView * _topView;
    // 可滚动新闻
    UIScrollView * _bottomScrollView;
    // 滚动滑块
    UIView * _animationView;
    //热预告数据数组
    NSMutableArray *_hotForecastDataArray;
    //关注度数据数组
    NSMutableArray *_attentionDataArray;
    //大家点数据数组
    NSMutableArray *_everyoneDataArray;
    
    //页码
    int focusNum;
    //将要发 从第几条数据开始
    int hotIndex;
    int atttentionIndex;
    int everyIndex;
    
    BOOL ishotRefresh;
    BOOL isattentionRefresh;
    BOOL iseveryoneRefresh;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _hotForecastDataArray = [[NSMutableArray alloc]init];
        _attentionDataArray = [[NSMutableArray alloc]init];
        _everyoneDataArray = [[NSMutableArray alloc]init];
        [FMDatabaseOP shareInstance];
        focusNum = 0;
        hotIndex = 0;
        atttentionIndex = 0;
        everyIndex = 0;
        isattentionRefresh = NO;
        iseveryoneRefresh = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}



- (void)setHeadView
{
//    HeadView *headView = [[HeadView alloc] init];
//    UIButton* leftbutton = [self backButton];
//    [headView setLeftButton:leftbutton];
//    [_backGroundView addSubview:headView];
//    [headView setTitle:@"您点菜"];
    self.title=@"您点菜";

    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEWCONTROLLERWIDTH, 40)];
    _topView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_backGroundView addSubview:_topView];
    
    NSArray * arr = @[@"热预告",@"关注度",@"大家点",@"我来点"];
    for (int i = 0; i < arr.count; i++) {
        UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(VIEWCONTROLLERWIDTH/arr.count*i, 0, VIEWCONTROLLERWIDTH/arr.count, 40);
        b.tag = BUTTONTAG+i;
        [b setTitle:arr[i] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor colorWithHexString:@"#343434"] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor colorWithHexString:@"#0f66c3"] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:b];
        
        if (i >0 ) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(VIEWCONTROLLERWIDTH/arr.count*i-0.5, 0, 1, 40)];
            line.backgroundColor = [UIColor colorWithHexString:LINECOLOR];
            [_topView addSubview:line];
        }
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.frame.size.height-1, _topView.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithHexString:LINECOLOR];
    [_topView addSubview:line];
    
    _animationView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height-3, _topView.frame.size.width/arr.count, 3)];
    _animationView.backgroundColor = [UIColor colorWithHexString:@"#1362c7"];
    [_topView addSubview:_animationView];
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height+_topView.frame.origin.y, VIEWCONTROLLERWIDTH, _backGroundView.frame.size.height-_topView.frame.size.height-_topView.frame.origin.y-64)];
    _bottomScrollView.bounces = NO;
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    _bottomScrollView.contentSize = CGSizeMake(VIEWCONTROLLERWIDTH*arr.count, _backGroundView.frame.size.height-_topView.frame.size.height-_topView.frame.origin.y-64);
    _bottomScrollView.pagingEnabled = YES;
    _bottomScrollView.delegate = self;
    [_backGroundView addSubview:_bottomScrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, self.view.frame.size.height)];
    _backGroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backGroundView];
    [self setHeadView];
    [self setDownView];
}

- (void)setDownView
{
    HotForecastTableView *hot = [[HotForecastTableView alloc]initWithFrame:CGRectMake(0, 0, _bottomScrollView.frame.size.width, _bottomScrollView.frame.size.height)];
    hot.nav = self.navigationController;
    [_bottomScrollView addSubview:hot];
    
    AttentionTableView *attention = [[AttentionTableView alloc]initWithFrame:CGRectMake(_bottomScrollView.frame.size.width, 0, _bottomScrollView.frame.size.width, _bottomScrollView.frame.size.height)];
    attention.nav = self.navigationController;
    [_bottomScrollView addSubview:attention];
    
    EveryoneChooseTableView *every = [[EveryoneChooseTableView alloc]initWithFrame:CGRectMake(_bottomScrollView.frame.size.width*2, 0, _bottomScrollView.frame.size.width, _bottomScrollView.frame.size.height)];
    every.nav = self.navigationController;
    [_bottomScrollView addSubview:every];
    
    //热度箭头
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(285, 5, 25, _bottomScrollView.frame.size.height-10)];
    arrow.image = [UIImage imageNamed:@"list_left_focuse.png"];
    arrow.backgroundColor = [UIColor clearColor];
    [_bottomScrollView addSubview:arrow];
    
    MyChooseView *myChoose = [[MyChooseView alloc]initWithFrame:CGRectMake(VIEWCONTROLLERWIDTH*3, 0, VIEWCONTROLLERWIDTH, _bottomScrollView.frame.size.height)];
    [_bottomScrollView addSubview:myChoose];
    //    UIView *my = [UIView alloc]initWithFrame:<#(CGRect)#>
    [self setTextColorWithOldState:0 newState:0];
}

- (void)setTextColorWithOldState:(NSInteger)oldNum newState:(NSInteger)newNum
{
    UIButton *oldButton = (UIButton*)[_topView viewWithTag:BUTTONTAG+oldNum];
    if (oldNum == newNum) {
        [oldButton setTitleColor:[UIColor colorWithHexString:@"#0f66c3"] forState:UIControlStateNormal];
        return;
    }else{
        UIButton *newButton = (UIButton*)[_topView viewWithTag:BUTTONTAG+newNum];
        [oldButton setTitleColor:[UIColor colorWithHexString:@"#343434"] forState:UIControlStateNormal];
        [newButton setTitleColor:[UIColor colorWithHexString:@"#0f66c3"] forState:UIControlStateNormal];
    }
}

// 点击事件关联滑块与下方的tableView
- (void)click:(UIButton *)button
{
    // 点击哪个按钮 滑块就滑动到哪个按钮下
    [UIView animateWithDuration:0.3 animations:^{
        [self setTextColorWithOldState:focusNum newState:button.tag-BUTTONTAG];
        focusNum = (int)button.tag-BUTTONTAG;
        _animationView.frame = CGRectMake(button.frame.origin.x, 37, _topView.frame.size.width/4, 3);
    }];
    
    long temp = button.tag - 100;
    // 点击第几个按钮 切换到对应的tableView
    [_bottomScrollView scrollRectToVisible:CGRectMake(temp*VIEWCONTROLLERWIDTH,0,VIEWCONTROLLERWIDTH,VIEWCONTROLLERHEIGHT-104) animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - UIScrollViewDelegate
// 下方的tableView关联上方的按钮和滑块
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bottomScrollView) {
        int page = scrollView.contentOffset.x / VIEWCONTROLLERWIDTH;
        [UIView animateWithDuration:0.3 animations:^{
            [self setTextColorWithOldState:focusNum newState:page];
            focusNum = page;
            _animationView.frame = CGRectMake(page*VIEWCONTROLLERWIDTH/4, 37,_topView.frame.size.width/4, 3);
        }];
    }
    [self.view endEditing:YES];
}

- (NSString*)getCurrentTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc ]  init ];
    [formatter setDateFormat:TOFORMAT];
    NSString *todayTime = [formatter stringFromDate:today];
    return todayTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

