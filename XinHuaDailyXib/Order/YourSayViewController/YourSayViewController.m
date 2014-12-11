//
//  YourSayViewController.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/21.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//
#define VIEWCONTROLLERWIDTH self.view.frame.size.width
#define VIEWCONTROLLERHEIGHT self.view.frame.size.height
#define TIMETYPE @"-1"
#import "YourSayViewController.h"
#import "UIColor+Hex.h"
#import "SayContentCell.h"
#import "CommentView.h"
#import "CommentViewController.h"
#import "NSString+SBJSON.h"
#import "CommentModel.h"
#import "OrderCommentCell.h"
#import "ASIFormDataRequest.h"
#import "XHRequest.h"
#import "NSString+Addtions.h"
#import "MJRefresh.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"

@interface YourSayViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CommentViewClickDelegate,ASIHTTPRequestDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSString *_requestTime;
    NSString *_literID;
}
@end

@implementation YourSayViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray = [NSMutableArray array];
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tableView headerBeginRefreshing];
}

- (UIButton*)backButton
{
    UIButton* leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 45, 45)];
    leftbutton.layer.masksToBounds = YES;
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"button_topback_default"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"button_topback_pressdown"] forState:UIControlStateSelected];
    [leftbutton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    return leftbutton;
}

- (void)goBack:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setHeadView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 280, self.view.frame.size.height-114) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing:)];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing:)];
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @"数据更新中";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中,不客气";
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    CGRect frame = CGRectMake(0, _tableView.frame.size.height, 280, 50);
    CommentView *comment = [[CommentView alloc]initWithHintString:@"我想说" delegate:self frame:frame];
    [self.view addSubview:comment];
    
    [_tableView footerEndRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我想说";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [self setHeadView];
}

- (void)headerRereshing:(MJRefreshHeaderView*)mjHeaderView
{
    if (_dataArray.count!=0) {
        HotForecastModel *model = _dataArray[0];
        _requestTime = [model.creatTime getToFormatTime];
        [self requestData:1 andRequestType:-1];
    }else{
        _requestTime = [self getCurrentTime];
        [self requestData:-1 andRequestType:-1];
    }
    [_tableView headerEndRefreshing];
}

- (void)footerRereshing:(MJRefreshHeaderView*)mjHeaderView
{
    //-(NSMutableArray *)selectFromCommentTableWithliterId:(NSString *)literid Start:(int)start recordMaxCount:MAX_COUNT
    CommentModel *model = _dataArray[_dataArray.count-1];
    NSArray *array = [[FMDatabaseOP shareInstance]selectFromCommentTableWithliterId:model.literID  Start:_dataArray.count+1 recordMaxCount:MAX_COUNT];
    if (array.count==0&&_dataArray.count==0) {
        _requestTime = [self getCurrentTime];
        [self requestData:-1 andRequestType:1];
    }else if(_dataArray.count!=0&&array.count==0){
        model = _dataArray[_dataArray.count-1];
        _requestTime = [model.creatTime getToFormatTime];
        [self requestData:-1 andRequestType:1];
    }else if(array.count!=0) {
        [_dataArray addObjectsFromArray:array];
    }
    [_tableView reloadData];
    [_tableView footerEndRefreshing];
}

//请求数据放入数据库中 (requestType -1下拉 1上拉)
- (void)requestData:(int)timeType andRequestType:(int)requestType
{
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",MAX_COUNT],@"n", APPID,@"appid",_requestTime,@"time",@"",@"isdeleted",[NSString stringWithFormat:@"%d",timeType],@"timetype",self.model.ID,@"mid",nil];
    [[XHRequest shareInstance] POST_Path:@"Common_GetLiterMemoComment.ashx" params:postDic completed:^(id JSON, NSString *stringData) {
        NSDictionary *jsonDict = [stringData JSONValue];
        if ([jsonDict[@"type"]isEqualToString:@"0"]) {
            NSArray *jsonArray = jsonDict[@"data"];
            if(jsonArray.count!=0){
                for (NSDictionary *dic in jsonArray)
                {
//                    if ([[[dic objectForKey:@"state"]URLDecodedString]isEqualToString:@"2"]) {
//                        [[FMDatabaseOP shareInstance]deleteDataWithId:[[dic objectForKey:@"ID"] URLDecodedString]andTableType:comment_table_type];
//                        continue;
//                    }
                    CommentModel *model = [[CommentModel alloc]init];
                    model.ID = [[dic objectForKey:@"ID"] URLDecodedString];
                    model.author = [[dic objectForKey:@"user"] URLDecodedString];
                    model.commentContent = [[dic objectForKey:@"content"] URLDecodedString];
                    model.creatTime = [[dic objectForKey:@"created_at"] URLDecodedString];
                    model.literID = [[dic objectForKey:@"literID"] URLDecodedString];
                    model.state = [[[dic objectForKey:@"state"] URLDecodedString] URLDecodedString];
                    [[FMDatabaseOP shareInstance] insertIntoDB:model table_type:comment_table_type];
                    _literID = model.literID;
                }
                if (requestType==-1) {
                    [_dataArray removeAllObjects];
                    _dataArray = [[FMDatabaseOP shareInstance]selectFromCommentTableWithliterId:_literID Start:0 recordMaxCount:MAX_COUNT+_dataArray.count];
                }else if(requestType==1){
                    [_dataArray addObjectsFromArray:[[FMDatabaseOP shareInstance]selectFromCommentTableWithliterId:_literID Start:_dataArray.count recordMaxCount:MAX_COUNT]];
                }
            }
            [_tableView reloadData];
        }
    } failed:^(NSError *error) {
        if (requestType==-1) {
            if (_dataArray.count==0) {
                _dataArray = [[FMDatabaseOP shareInstance]selectFromCommentTableWithliterId:_literID Start:0 recordMaxCount:MAX_COUNT];
            }
        }else if(requestType==1){
            [_dataArray addObjectsFromArray:[[FMDatabaseOP shareInstance]selectFromCommentTableWithliterId:_literID Start:_dataArray.count recordMaxCount:MAX_COUNT]];
        }
        [_tableView reloadData];
    }];
}

- (NSString*)getCurrentTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc ]  init ];
    [formatter setDateFormat:TOFORMAT];
    NSString *todayTime = [formatter stringFromDate:today];
    return todayTime;
}
      
- (void)commentViewClick
{
    CommentViewController *comment = [[CommentViewController alloc]init];
    comment.commentID = self.model.ID;
    [self.navigationController pushViewController:comment animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"content";
    static NSString *identifier2 = @"comment";
    if (indexPath.row==0) {
        SayContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[SayContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        [cell setStatus:self.model];
        return cell;
    }else{
        OrderCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell)
        {
            cell = [[OrderCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        CommentModel *model = _dataArray[indexPath.row-1];
        [cell setStatus:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.model.contentSize.height+50+self.model.titleSize.height;
    }
    CommentModel *model = _dataArray[indexPath.row-1];
    return model.commentContentSize.height+60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
