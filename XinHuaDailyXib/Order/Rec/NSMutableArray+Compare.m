//
//  NSMutableArray+Compare.m
//  XHJR
//
//  Created by 胡世骞 on 14/12/8.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "NSMutableArray+Compare.h"
#import "HotForecastModel.h"
#import "CommentModel.h"
@implementation NSMutableArray (Compare)
- (void)addObjectToArray:(id)model headOrFinally:(BOOL)ishead
{
    if(ishead){
        if ([model isKindOfClass:[HotForecastModel class]]) {
            HotForecastModel *_model = (HotForecastModel*)model;
            for (HotForecastModel* data in self) {
                if ([data.ID isEqualToString:_model.ID]) {
                    return;
                }
            }
            [self insertObject:_model atIndex:0];
        }else{
            CommentModel *_model = (CommentModel*)model;
            for (CommentModel* data in self) {
                if ([data.ID isEqualToString:_model.ID]) {
                    return;
                }
            }
            [self insertObject:_model atIndex:0];
        }
    }else{
        if ([model isKindOfClass:[HotForecastModel class]]) {
            HotForecastModel *_model = (HotForecastModel*)model;
            for (HotForecastModel* data in self) {
                if ([data.ID isEqualToString:_model.ID]) {
                    return;
                }
            }
            [self addObject:_model];
        }else{
            CommentModel *_model = (CommentModel*)model;
            for (CommentModel* data in self) {
                if ([data.ID isEqualToString:_model.ID]) {
                    return;
                }
            }
            [self addObject:_model];
        }
    }
}
@end
