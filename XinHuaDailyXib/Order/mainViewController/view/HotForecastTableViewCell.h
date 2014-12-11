//
//  HotForecastTableViewCell.h
//  order
//
//  Created by 胡世骞 on 14/11/15.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotForecastModel.h"
@interface HotForecastTableViewCell : UITableViewCell
@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,weak) UITableView * tableview;
-(void)setStatus:(HotForecastModel *)model;
@end
