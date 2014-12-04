//
//  SayContentCell.h
//  YourOrder
//
//  Created by 胡世骞 on 14/11/25.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface SayContentCell : UITableViewCell
-(void)setStatusWithTitle:(NSString*)title content:(NSString*)content andHeight:(CGFloat)contentHeight;
@end