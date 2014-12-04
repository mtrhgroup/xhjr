//
//  CommentView.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/25.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "CommentView.h"
#import "UIColor+Hex.h"
@implementation CommentView
{
    NSString *_placeholder;
    CGRect _frame;
    id<CommentViewClickDelegate> _delegate;
}

- (id)initWithHintString:(NSString*)placeholder delegate:(id)delegate frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _placeholder = placeholder;
        frame.origin.x = 0;
        frame.origin.y = 0;
        _frame = frame;
        _delegate = delegate;
        [self createView];
    }
    return self;
}
- (void)createView
{
    UIView *editViewBG = [[UIView alloc]initWithFrame:_frame];
    editViewBG.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self addSubview:editViewBG];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, editViewBG.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#c8c8c8"];
    [editViewBG addSubview:line];
    
    UIButton *textFieldBG = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, editViewBG.frame.size.width-20, editViewBG.frame.size.height-20)];
    textFieldBG.layer.masksToBounds = YES;
    textFieldBG.layer.cornerRadius = 5;
    [textFieldBG.layer setBorderWidth:0.8];
    [textFieldBG.layer setBorderColor:[UIColor colorWithHexString:@"#c8c8c8"].CGColor];
    [textFieldBG addTarget:self action:@selector(editBGClick:) forControlEvents:UIControlEventTouchUpInside];
    textFieldBG.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [editViewBG addSubview:textFieldBG];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    imageView.userInteractionEnabled = NO;
    imageView.image = [UIImage imageNamed:@"pic_writecomments_default"];
    [textFieldBG addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width, imageView.frame.origin.y, textFieldBG.frame.size.width-imageView.frame.origin.x*2+imageView.frame.size.width, 20)];
    label.text = @"我想说";
    label.userInteractionEnabled = NO;
    label.textColor = [UIColor colorWithHexString:@"#c6c6c6"];
    [textFieldBG addSubview:label];
}

- (void)editBGClick:(UIButton*)sender
{
    [_delegate commentViewClick];
}

@end
