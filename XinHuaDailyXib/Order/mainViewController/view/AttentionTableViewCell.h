//
//  AttentionTableViewCell.h
//  YourOrder
//
//  Created by 胡世骞 on 14/11/18.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotForecastModel.h"
#import "OrderViewController.h"
@interface AttentionTableViewCell : UITableViewCell
@property (nonatomic,strong)UINavigationController *nav;
-(void)setStatus:(HotForecastModel *)model andHeight:(CGFloat)contentHeight;
@end
