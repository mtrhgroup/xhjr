//
//  XHHeadView.m
//  YourOrder
//
//  Created by 胡世骞 on 14/12/2.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "XHHeadView.h"
#import "UIColor+Hex.h"
@implementation XHHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

/**
 * 初始化页面
 */
- (void)initView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect rect = CGRectMake(0, 0, frame.size.width, 44);
    self.frame = rect;
    self.backgroundColor = [UIColor clearColor];
    _backgroundView = [[UIImageView alloc] initWithFrame:self.frame];
    //    _backgroundView.image = [UIImage imageNamed:@"head.png"];
    _backgroundView.backgroundColor = [UIColor colorWithHexString:@"#1063c9"];
    [self addSubview:_backgroundView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    _titleLabel.text = @"新华金融";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.center = self.center;
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
    if (title.length > 9) {
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
}

- (NSString*)title
{
    return _titleLabel.text;
}

- (void)setLeftButton:(UIButton *)leftButton
{
    [_leftButton removeFromSuperview];
    _leftButton = leftButton;
    CGRect rect = leftButton.frame;
    CGFloat width = rect.size.width;
    CGPoint center = CGPointMake(width/2, self.frame.size.height/2);
    self.leftButton.center = center;
    [self addSubview:_leftButton];
}

- (void)setRightButton:(UIButton *)rightButton
{
    [_rightButton removeFromSuperview];
    _rightButton = rightButton;
    CGRect rect = rightButton.frame;
    CGFloat width = rect.size.width;
    CGPoint center = CGPointMake(320 - width/2, self.frame.size.height/2);
    self.rightButton.center = center;
    [self addSubview:_rightButton];
}
@end
