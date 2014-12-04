//
//  HotForecastModel.m
//  order
//
//  Created by 胡世骞 on 14/11/15.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "HotForecastModel.h"
@implementation HotForecastModel

- (void)setContent:(NSString *)content
{
    if (_content != content) {
        _content = content;
        // 完整显示个性签名的控件的宽高
        if (!SYSTEM_VERSION) {
            _contentSize = [_content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(192, 2000)];
        }else{
            _contentSize= [_content boundingRectWithSize:CGSizeMake(APPLICATIONFRAME.width-23, 2000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        }
    }
}
@end
