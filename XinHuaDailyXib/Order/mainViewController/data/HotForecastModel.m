//
//  HotForecastModel.m
//  order
//
//  Created by 胡世骞 on 14/11/15.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "HotForecastModel.h"
@implementation HotForecastModel

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        // 完整显示个性签名的控件的宽高
        float wight = 185;
        if(_type == 2)
        {
            wight = 215;
        }
        
        if (!SYSTEM_VERSION) {
            _titleSize = [_title sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(wight, MAXFLOAT)];
        }else{
            _titleSize= [_title boundingRectWithSize:CGSizeMake(wight, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} context:nil].size;
        }
    }
}

- (void)setContent:(NSString *)content
{
    if (_content != content) {
        _content = content;
        // 完整显示个性签名的控件的宽高
        float wight = 185;
        if(_type == 2)
        {
            wight = 215;
        }
        
        if (!SYSTEM_VERSION) {
            _contentSize = [_content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(wight, MAXFLOAT)];
        }else{
            _contentSize= [_content boundingRectWithSize:CGSizeMake(wight, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
        }
    }
}
- (NSComparisonResult)compare: (HotForecastModel *)otherModel
{
    NSString *time1;
    NSString *time2;
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    if (self.noticeTime.length ==0) {
        time1 = self.creatTime;
        time2 = otherModel.creatTime;
        [formater setDateFormat:WITHFORMAT];
    }else{
        time1 = self.noticeTime;
        time2 = otherModel.noticeTime;
        [formater setDateFormat:DATEFORMAT];
    }
    NSDate* date1 = [formater dateFromString:time1];
    NSDate *date2 = [formater dateFromString:time2];
    NSComparisonResult result = [date1 compare:date2];
    return result == NSOrderedAscending;  // 降序
}
@end
