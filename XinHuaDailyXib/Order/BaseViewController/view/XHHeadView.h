//
//  XHHeadView.h
//  YourOrder
//
//  Created by 胡世骞 on 14/12/2.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHHeadView : UIView
@property (nonatomic, retain) UIImageView* backgroundView;
@property (nonatomic, retain) UIButton* leftButton;
@property (nonatomic, retain) UIButton* rightButton;
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) NSString* title;
/**
 *  初始化视图
 *
 *  @return
 */
- (void)initView;
@end
