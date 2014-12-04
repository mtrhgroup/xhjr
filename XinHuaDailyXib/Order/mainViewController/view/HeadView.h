//
//  HeadView.h
//  YourOrder
//
//  Created by 胡世骞 on 14/11/20.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView

@property (nonatomic, strong) UIImageView* backgroundView;
@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UIButton* rightButton;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) NSString* title;

/**
 *  初始化视图
 *
 *  @return
 */
//- (void)initView;
@end