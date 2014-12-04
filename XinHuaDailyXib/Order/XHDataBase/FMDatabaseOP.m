//
//  FMDatabaseOP.h
//  XHJR
//
//  Created by luob on 14-12-3.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//
#import "FMDatabaseOP.h"

// 非线程安全
#import "FMDatabase.h"
// 线程安全
#import "FMDatabaseQueue.h"
#import "HotForecastModel.h"
#import "CommentModel.h"



@implementation FMDatabaseOP
{
    FMDatabaseQueue * _dbQueue;
}

static FMDatabaseOP * instance = nil;

// 静态数据区 只有程序退出时 才会被系统回收
+(FMDatabaseOP *)shareInstance
{

    if (instance == nil) {
        instance = [[FMDatabaseOP alloc] init];
    }
    return instance;
}

/*
 id 既可以当参数 又能当返回值
 instancetype 只能当返回值  动态匹配对象的数据类型
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString * dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/XHJRDatebase.db"];
        NSLog(@"DB path is %@",dbPath);
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        // inDatabase方法中已经打开了数据库 形参传递至block中
            NSString *sql_hotforecast_table = @"create table if not exists hotforecast_table (id text not null,create_at text,notice_date text,title text,content text,user text,comment_count text,focus_count text, primary key(id));";
            
            NSString *sql_focus_table = @"create table if not exists focus_table (id text not null,create_at text,notice_date text,title text,content text,user text,comment_count text,focus_count text, primary key(id));";
            
            NSString *sql_yousay_table = @"create table if not exists yousay_table (id text not null,create_at text,notice_date text,title text,content text,user text,comment_count text,focus_count text, primary key(id));";
            
            NSString *sql_comment_table = @"create table if not exists comment_table (id text not null,create_at text,content text,user text,literid text, primary key(id));";
        [self executesql:sql_hotforecast_table];
        [self executesql:sql_focus_table];
        [self executesql:sql_yousay_table];
        [self executesql:sql_comment_table];
            

    }
    return self;
}




/*
  执行sql语句
 */
-(void)executesql:(NSString *)sql
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
    if (![db executeUpdate:sql]) {
        NSLog(@"SQLstatement:%@ error!",sql);
    }
    }];
}

/*
 插入数据库 data 数据对象   type 要插入那个表
 */
-(void)insertIntoDB:(id)data table_type:(int)type
{
    NSString * sql = nil;
    HotForecastModel *model = nil;
    CommentModel * commentmodel = nil;
    switch (type) {
        case hotforecast_table_type:
            sql = @"replace into hotforecast_table (id,create_at,notice_date,title,content,user,comment_count,focus_count) values (?,?,?,?,?,?,?,?)";

            break;
        case focus_table_type:
            sql = @"replace into focus_table (id,create_at,notice_date,title,content,user,comment_count,focus_count) values (?,?,?,?,?,?,?,?)";
            break;
        case yousay_table_type:
            sql = @"replace into yousay_table (id,create_at,notice_date,title,content,user,comment_count,focus_count) values (?,?,?,?,?,?,?,?)";
            break;
        case comment_table_type:
            sql = @"replace into comment_table (id,create_at,content,user,literid) values (?,?,?,?,?)";
            
            /*
             @interface CommentModel : NSObject
             @property (nonatomic,copy)NSString *author;
             @property (nonatomic,copy)NSString *commentContent;
             @property (nonatomic,copy)NSString *creatTime;
             @property (nonatomic,copy)NSString *literID;
             @property (nonatomic,copy)NSString *ID;*/
            
            commentmodel = (CommentModel*)data;
            [_dbQueue inDatabase:^(FMDatabase *db) {
                //执行sql语句
                if (![db executeUpdate:sql,commentmodel.ID,commentmodel.creatTime,commentmodel.commentContent,commentmodel.author,commentmodel.literID])
                {
                    NSLog(@"插入数据失败");
                }
                else
                {
                    NSLog(@"插入数据成功");
                }
            }];
            return;
            
    }
    
    model = (HotForecastModel*)data;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //执行sql语句
        if (![db executeUpdate:sql,model.ID,model.creatTime,model.noticeTime,model.title,model.content,model.user,model.comment_count,model.focus_count])
        {
            NSLog(@"插入数据失败");
        }
        else
        {
            NSLog(@"插入数据成功");
        }
    }];

}

/**
 数据清除 table_type ：table_type
 **/
-(void)clearData:(int)table_type
{
    NSString * sql = nil;
    switch (table_type) {
        case hotforecast_table_type:
//            sql = @"drop table if exists hotforecast_table;create table if not exists hotforecast_table (id text not null,create_at text,notice_date text,title text,content text,user text,comment_count text,focus_count text, primary key(id));";
            sql = @"delete from hotforecast_table;";
            break;
        case focus_table_type:
//            sql = @"drop table if exists focus_table;create table if not exists focus_table (id text not null,create_at text,notice_date text,title text,content text,user text,comment_count text,focus_count text, primary key(id));";
            sql = @"delete from focus_table;";
            break;
        case yousay_table_type:
//            sql = @"drop table if exists yousay_table;create table if not exists yousay_table (id text not null,create_at text,notice_date text,title text,content text,user text,comment_count text,focus_count text, primary key(id));";
            sql = @"delete from yousay_table;";
             break;
            
        case comment_table_type:
//            sql = @"drop table if exists comment_table;create table if not exists comment_table (id text not null,create_at text,content text,user text,literid text, primary key(id));";
            sql = @"delete from comment_table;";
             break;
    }
    if (sql !=nil) {
        [self executesql:sql];
    }
    
}

/**
 获取数据 literid 评论点题的id  start 从第几条数据开始  maxcount 要获取的记录数
 **/
-(NSMutableArray *)selectFromCommentTableWithliterId:(NSString *)literid Start:(int)start recordMaxCount:(int)maxcount
{
    NSString * sql = @"select * from comment_table where literid=%@ order by create_at desc limit %d,%d";
    
    __block NSMutableArray * array = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * result = [db executeQuery:[NSString stringWithFormat:sql,literid,start,maxcount]];
        while ([result next]) {
            //从根据字段取值
            //封装成model对象
            CommentModel *model = [[CommentModel alloc] init];
            model.ID = [result stringForColumn:@"id"];
            model.creatTime = [result stringForColumn:@"create_at"];
            model.commentContent = [result stringForColumn:@"content"];
            model.author = [result stringForColumn:@"user"];
            model.literID = [result stringForColumn:@"literid"];
            [array addObject:model];
        }
    }];
    return array;
}


/**
 获取数据  start 从第几条数据开始  maxcount 要获取的记录数
 **/
-(NSMutableArray *)selectFromDBWithStart:(int)start recordMaxCount:(int)maxcount tableType:(int)table_type
{
    NSString * sql = nil;
    switch (table_type) {
        case hotforecast_table_type:
            sql = @"select * from hotforecast_table order by notice_date desc, create_at desc limit %d,%d";
            break;
        case focus_table_type:
            sql = @"select * from focus_table order by focus_count desc, create_at desc limit %d,%d";
            break;
        case yousay_table_type:
            sql = @"select * from yousay_table order by create_at desc limit %d,%d";
            break;
    }
    
    __block NSMutableArray * array = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * result = [db executeQuery:[NSString stringWithFormat:sql,start,maxcount]];
        while ([result next]) {
            //从根据字段取值
            //封装成model对象
            HotForecastModel *model = [[HotForecastModel alloc] init];
            model.ID = [result stringForColumn:@"id"];
            model.creatTime = [result stringForColumn:@"create_at"];
            model.noticeTime = [result stringForColumn:@"notice_date"];
            model.title = [result stringForColumn:@"title"];
            model.content = [result stringForColumn:@"content"];
            model.user = [result stringForColumn:@"user"];
            model.comment_count = [result stringForColumn:@"comment_count"];
            model.focus_count = [result stringForColumn:@"focus_count"];
            [array addObject:model];
        }
    }];
    return array;
}


-(void)closeDB
{
    [_dbQueue close];
    instance = nil;
}



@end
