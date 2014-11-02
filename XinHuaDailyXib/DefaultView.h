//
//  KidsDefaultView.h
//  kidsgarden
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"

@interface DefaultView : UIView
@property(nonatomic,strong)Service *service;
-(void)show;
-(void)hide;
@end
