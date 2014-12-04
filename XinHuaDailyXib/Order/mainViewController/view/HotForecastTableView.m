//
//  HotForecastTableView.m
//  XHJR
//
//  Created by 胡世骞 on 14/12/3.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "HotForecastTableView.h"
#import "MJRefresh.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "FMDatabaseOP.h"
#import "XHRequest.h"
#import "NSString+SBJSON.h"
#import "NSString+Addtions.h"
#import "HotForecastTableViewCell.h"
#import "HotForecastModel.h"

@interface HotForecastTableView()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    CGRect _frame;
    NSMutableArray *_dataArray;
    NSString *_requestTime;
}
@end
@implementation HotForecastTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self createView];
    }
    return self;
}

- (void)createView
{
    _tableView = [[UITableView alloc]initWithFrame:_frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing:)];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing:)];
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @"数据更新中";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"MJ哥正在帮你加载中,不客气";
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    [_tableView headerBeginRefreshing];
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
    NSArray *array = [[FMDatabaseOP shareInstance]selectFromDBWithStart:(int)_dataArray.count+1 recordMaxCount:MAX_COUNT tableType:hotforecast_table_type];
    if (array.count==0&&_dataArray.count==0) {
        _requestTime = [self getCurrentTime];
        [self requestData:-1 andRequestType:1];
    }else if(_dataArray.count!=0&&array.count==0){
        HotForecastModel *model = _dataArray[_dataArray.count-1];
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
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",MAX_COUNT],@"n", APPID,@"appid",_requestTime,@"time",@"",@"isdeleted",[NSString stringWithFormat:@"%d",timeType],@"timetype",@"focus",@"type",nil];
    
    [[XHRequest shareInstance] POST_Path:@"Common_GetLiterMemo.ashx" params:postDic completed:^(id JSON, NSString *stringData) {
        NSDictionary *jsonDict = [stringData JSONValue];
        //        if ([jsonDict[@"type"]isEqualToString:@"1"]) {
        //            [[FMDatabaseOP shareInstance]clearData:focus_table_type];
        //        }
        NSArray *jsonArray = jsonDict[@"data"];
        if(jsonArray.count!=0){
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dic in jsonArray)
            {
                HotForecastModel *model = [[HotForecastModel alloc]init];
                model.ID = [[dic objectForKey:@"ID"] URLDecodedString];
                model.user = [[dic objectForKey:@"user"] URLDecodedString];
                model.content = [[dic objectForKey:@"content"] URLDecodedString];
                model.title = [[dic objectForKey:@"title"] URLDecodedString];
                model.noticeTime = [[dic objectForKey:@"notice_date"] URLDecodedString];
                model.creatTime = [[dic objectForKey:@"created_at"] URLDecodedString];
                model.focus_count = [[dic objectForKey:@"focus_count"] URLDecodedString];
                model.comment_count = [[dic objectForKey:@"comment_count"] URLDecodedString];
                [[FMDatabaseOP shareInstance] insertIntoDB:model table_type:hotforecast_table_type];
                [tempArray addObject:model];
            }
            if (requestType==1) {
                [_dataArray addObjectsFromArray:tempArray];
            }else{
                [tempArray addObjectsFromArray:_dataArray];
                _dataArray = tempArray;
            }
            [_tableView reloadData];
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据加载完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alter show];
        }
    } failed:^(NSError *error) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"hotForecast";
    HotForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[HotForecastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HotForecastModel *model = _dataArray[indexPath.row];
    cell.nav = self.nav;
    [cell setStatus:model andHeight:model.contentSize.height];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotForecastModel *model = _dataArray[indexPath.row];
    return model.contentSize.height+90;
}

- (NSString*)getCurrentTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc ]  init ];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayTime = [formatter stringFromDate:today];
    return todayTime;
}
@end
