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
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:WITHFORMAT];
        NSDate *d=[date dateFromString:_creatTime];
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSCalendar *chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSUInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit | NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
        
        NSDateComponents *DateComponent = [chineseClendar components:unitFlags fromDate:d toDate:dat options:0];
        
        NSInteger diffHour = [DateComponent hour];
        
        NSInteger diffMin    = [DateComponent minute];
        
        NSInteger diffSec   = [DateComponent second];
        
        NSInteger diffDay   = [DateComponent day];
        
        NSInteger diffMon  = [DateComponent month];
        
        NSInteger diffYear = [DateComponent year];
        
        if (diffYear>0) {
            _forNow=[NSString stringWithFormat:@"%ld 年前",(long)diffYear];
        }else if(diffMon>0){
            _forNow=[NSString stringWithFormat:@"%ld 月前",(long)diffMon];
        }else if(diffDay>0){
            _forNow=[NSString stringWithFormat:@"%ld 天前",(long)diffDay];
        }else if(diffHour>0){
            _forNow=[NSString stringWithFormat:@"%ld 小时前",(long)diffHour];
        }else if(diffMin>0){
            _forNow=[NSString stringWithFormat:@"%ld 分钟前",(long)diffMin];
        }else if(diffSec>0){
//            _forNow=[NSString stringWithFormat:@"%ld 秒前",(long)diffSec];
            _forNow=[NSString stringWithFormat:@"刚刚"];
        }else{
            _forNow=[NSString stringWithFormat:@"未知时间"];
        }
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
