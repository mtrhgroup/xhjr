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
            _commentContentSize = [_commentContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(182, 2000)];
        }else{
            _commentContentSize= [_commentContent boundingRectWithSize:CGSizeMake(182, 2000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        }
    }
}

- (void)setCreatTime:(NSString *)creatTime
{
    if (_creatTime != creatTime) {
        _creatTime = creatTime;
        //Tue May 21 10:56:45 +0800 2013
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:@"YYYY-MM-DD hh:mm:ss"];
        NSDate *d=[date dateFromString:_creatTime];
        
        NSTimeInterval late=[d timeIntervalSince1970]*1;
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now=[dat timeIntervalSince1970]*1;
        NSString *timeString=@"";
        
        NSTimeInterval cha=now-late;
        if (cha/60<1){
            timeString=[NSString stringWithFormat:@"刚刚"];
        }else if (cha/60>1&&cha/3600<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
            
        }else if (cha/3600>1&&cha/86400<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        }else if (cha/86400>1)
        {
            timeString = [NSString stringWithFormat:@"%f", cha/86400];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@天前", timeString];
        }
        _forNow = timeString;
    }
}
@end
