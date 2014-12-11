//
//  CommentModel.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/25.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//
#define SYSTEM_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]>=7.000000
#import "CommentModel.h"

@implementation CommentModel
- (void)setCommentContent:(NSString *)commentContent
{
    if (_commentContent != commentContent) {
        _commentContent = commentContent;
        // 完整显示个性签名的控件的宽高
        if (!SYSTEM_VERSION) {
            _commentContentSize = [_commentContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(RIGHTVIEWWIGHT-90, 2000)];
        }else{
            _commentContentSize= [_commentContent boundingRectWithSize:CGSizeMake(RIGHTVIEWWIGHT-90, 2000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
        }
    }
}

- (void)setCreatTime:(NSString *)creatTime
{
    if (_creatTime != creatTime) {
        _creatTime = creatTime;
        _forNow = [_creatTime forNowTime];
    }
}
- (NSComparisonResult)compare: (CommentModel *)otherModel
{
    //    HotForecastModel *tempModel = (HotForecastModel *)self;
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    NSDate* date1 = [formater dateFromString:self.creatTime];
    NSDate *date2 = [formater dateFromString:otherModel.creatTime];
    NSComparisonResult result = [date1 compare:date2];
    return result == NSOrderedDescending;
}
@end
