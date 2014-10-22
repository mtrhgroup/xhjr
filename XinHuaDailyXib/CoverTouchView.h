//
//  KidsTouchRefreshView.h
//  kidsgarden
//
//  Created by apple on 14/6/30.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchViewDelegate.h"
@interface CoverTouchView : UIView
@property(nonatomic,assign)id<TouchViewDelegate>delegate;
-(id)initWithImage:(UIImage *)image frame:(CGRect)frame;
-(void)hide;
-(void)show;
@end
