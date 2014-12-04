//
//  BaseViewController.h
//  YourOrder
//
//  Created by 胡世骞 on 14/12/2.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHHeadView.h"
@interface BaseViewController : UIViewController
@property (nonatomic,strong)UIView* bgView;
/**
 *  标题栏视图
 */
@property (nonatomic,strong) XHHeadView* navigationView;
/**
 *  作为所有视图的父视图
 */
@property (nonatomic,strong) UIView* baseView;
@end
