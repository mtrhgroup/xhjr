//
//  woViewController.h
//  TestSwipeView
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSwipeViewController.h"

@interface SwipeViewController : RNSwipeViewController
<RNSwipeViewControllerDelegate>
-(void)resetView;
@end
