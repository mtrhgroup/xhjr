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
            _commentContentSize = [_commentContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(192, 2000)];
        }else{
            _commentContentSize= [_commentContent boundingRectWithSize:CGSizeMake(APPLICATIONFRAME.width-88, 2000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        }
    }
}
@end
