//
//  KidsNavigationController.h
//  kidsgarden
//
//  Created by apple on 14/7/21.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController
@property(nonatomic,strong)UIViewController *toPushVC;
-(void)setLeftButtonWithImage:(UIImage *)img target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(void)setRightButtonWithImage:(UIImage *)img target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(void)setRightButtonWithString:(NSString *)string target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
