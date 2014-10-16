//
//  KidsTouchRefreshView.h
//  kidsgarden
//
//  Created by apple on 14/6/30.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TouchViewDelegate <NSObject>
-(void)clicked;
@end
@interface TouchRefreshView : UIView
@property(nonatomic,strong)UIButton *touchView;
@property(nonatomic,assign)id<TouchViewDelegate>delegate;
-(void)hide;
-(void)show;
@end
