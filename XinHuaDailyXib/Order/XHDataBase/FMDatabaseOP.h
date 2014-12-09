//
//  FMDatabaseOP.h
//  XHJR
//
//  Created by luob on 14-12-3.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDatabaseOP : NSObject

+(FMDatabaseOP *)shareInstance;

-(void)executesql:(NSString *)sql;


-(void)insertIntoDB:(id)data table_type:(int)type;

-(void)clearData:(int)table_type;

- (void)deleteDataWithId:(NSString *)Id andTableType:(int)table_type;

-(NSMutableArray *)selectFromDBWithStart:(int)start recordMaxCount:(int)maxcount tableType:(int)table_type;

-(NSMutableArray *)selectFromCommentTableWithliterId:(NSString *)literid Start:(int)start recordMaxCount:(int)maxcount;

-(void)closeDB;

@end
