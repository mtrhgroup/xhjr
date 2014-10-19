//
//  KidsDefaultView.h
//  kidsgarden
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"
@protocol CoverViewDelegate <NSObject>
-(void)loadDataForMainVC;
@end

@interface DefaultView : UIView
@property(nonatomic,strong)Service *service;
@property(nonatomic,assign)id<CoverViewDelegate>delegate;
-(void)show;
-(void)hide;
@end
