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
        _frame = CGRectMake(0, 0, frame.size.width, frame.size.height+38);
        _dataArray = [NSMutableArray array];
        [self createView];
    }
    return self;
}

- (void)createView
{
    _tableView = [[UITableView alloc]initWithFrame:_frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing:)];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing:)];
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @"数据更新中";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中";
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
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",MAX_COUNT],@"n", APPID,@"appid",_requestTime,@"time",@"",@"isdeleted",[NSString stringWithFormat:@"%d",timeType],@"timetype",@"prevue",@"type",nil];
    
    [[XHRequest shareInstance] POST_Path:@"Common_GetLiterMemo.ashx" params:postDic completed:^(id JSON, NSString *stringData) {
        NSDictionary *jsonDict = [stringData JSONValue];
        //        if ([jsonDict[@"type"]isEqualToString:@"1"]) {
        //            [[FMDatabaseOP shareInstance]clearData:focus_table_type];
        //        }
        NSArray *jsonArray = jsonDict[@"data"];
        if(jsonArray.count!=0){
            for (NSDictionary *dic in jsonArray)
            {
                if ([[[dic objectForKey:@"state"]URLDecodedString]isEqualToString:@"2"]) {
                    [[FMDatabaseOP shareInstance]deleteDataWithId:[[dic objectForKey:@"ID"] URLDecodedString]andTableType:hotforecast_table_type];
                    continue;
                }
                HotForecastModel *model = [[HotForecastModel alloc]init];
                model.type = 1;
                model.ID = [[dic objectForKey:@"ID"] URLDecodedString];
                model.user = [[dic objectForKey:@"user"] URLDecodedString];
                model.content = [[dic objectForKey:@"content"] URLDecodedString];
                model.title = [[dic objectForKey:@"title"] URLDecodedString];
                model.noticeTime = [[dic objectForKey:@"notice_date"] URLDecodedString];
                model.creatTime = [[dic objectForKey:@"created_at"] URLDecodedString];
                model.focus_count = [[dic objectForKey:@"focus_count"] URLDecodedString];
                model.comment_count = [[dic objectForKey:@"comment_count"] URLDecodedString];
                model.state = [[dic objectForKey:@"state"]  URLDecodedString];
                [[FMDatabaseOP shareInstance] insertIntoDB:model table_type:hotforecast_table_type];
//                if ([self compareWithCurrentTime:model.noticeTime] &&![model.state isEqualToString:@"2"]) {
//                    if (requestType==1) {
//                        [_dataArray addObjectToArray:model headOrFinally:NO];
//                    }else{
//                        [_dataArray addObjectToArray:model headOrFinally:YES];
//                    }
//                }
            }
            if (requestType==-1) {
                [_dataArray removeAllObjects];
                _dataArray = [[FMDatabaseOP shareInstance]selectFromDBWithStart:0 recordMaxCount:MAX_COUNT+_dataArray.count tableType:hotforecast_table_type];
            }else if(requestType==1){
                [_dataArray addObjectsFromArray:[[FMDatabaseOP shareInstance]selectFromDBWithStart:_dataArray.count recordMaxCount:MAX_COUNT tableType:hotforecast_table_type]];
            }
            _dataArray = [[NSMutableArray alloc]initWithArray:[_dataArray sortedArrayUsingSelector:@selector(compare:)]];
            [_tableView reloadData];
        }
    } failed:^(NSError *error) {
        if (requestType==-1) {
            if (_dataArray.count==0) {
                _dataArray = [[FMDatabaseOP shareInstance]selectFromDBWithStart:0 recordMaxCount:MAX_COUNT tableType:hotforecast_table_type];
                [_tableView reloadData];
            }
        }else if(requestType==1){
            [_dataArray addObjectsFromArray:[[FMDatabaseOP shareInstance]selectFromDBWithStart:_dataArray.count recordMaxCount:MAX_COUNT tableType:hotforecast_table_type]];
            [_tableView reloadData];
        }
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
        cell = [[HotForecastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    HotForecastModel *model = _dataArray[indexPath.row];
    cell.nav = self.nav;
    [cell setStatus:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotForecastModel *model = _dataArray[indexPath.row];
    return model.contentSize.height+70+model.titleSize.height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSString*)getCurrentTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc ]  init ];
    [formatter setDateFormat:TOFORMAT];
    NSString *todayTime = [formatter stringFromDate:today];
    return todayTime;
}
-(BOOL)compareWithCurrentTime:(NSString*)timeStr
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:DATEFORMAT];
    
    NSDate *d=[formater dateFromString:timeStr];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha=now-late;
    if (cha>0) {
        return NO;
    }
    return YES;
}
@end
