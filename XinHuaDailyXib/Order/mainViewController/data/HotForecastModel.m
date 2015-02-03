//
//  HotForecastModel.m
//  order
//
//  Created by 胡世骞 on 14/11/15.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "HotForecastModel.h"
@implementation HotForecastModel

#define MAXLINES 3

-(id) init
{
    float wight ;
    if (_type==1) {
        wight = 185;
    }else if(_type == 2){
        wight = 215;
    }else{
        wight = 250;
    }
    if (lessiOS7) {
        _heightforone = [@" " sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(wight, MAXFLOAT)].height;
    }else{
        _heightforone= [@" " boundingRectWithSize:CGSizeMake(wight, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil].size.height;
    }
    _isShow = TRUE;
    return [super init];
}


- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        // 完整显示个性签名的控件的宽高
        float wight ;
        if (_type==1) {
            wight = 185;
        }else if(_type == 2){
            wight = 215;
        }else{
            wight = 250;
        }
        if (lessiOS7) {
            _titleSize = [_title sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(wight, MAXFLOAT)];
        }else{
            _titleSize= [_title boundingRectWithSize:CGSizeMake(wight, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil].size;
        }
    }
}

- (void)setContent:(NSString *)content
{
    if (_content != content) {
        _content = content;
        // 完整显示个性签名的控件的宽高
        float wight ;
        if (_type==1) {
            wight = 185;
        }else if(_type == 2){
            wight = 215;
        }else{
            wight = 250;
        }
        
        
        if (lessiOS7) {
            _contentSize = [_content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(wight, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        }else{
            _contentSize= [_content boundingRectWithSize:CGSizeMake(wight, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
        }
        if(content.length==0){
            _contentSize=CGSizeMake(0, 0);
        }
    }
}


-(float)getContenHeight
{

    if (_isShow) {
        if (_contentSize.height<=(_heightforone * MAXLINES+0.5)) {
            return _contentSize.height;
        }else
        {
            return _heightforone * MAXLINES+0.5;
        }
        
    }
    return _contentSize.height;
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
