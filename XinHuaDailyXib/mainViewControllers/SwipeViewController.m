//
//  woViewController.m
//  TestSwipeView
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SwipeViewController.h"
#import "woCenterViewController.h"
#import "woLeftViewController.h"
#import "woRightViewController.h"
#import "woBottomViewController.h"
#import "XinHuaViewController.h"

@interface SwipeViewController ()

@end

@implementation SwipeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.centerViewController =[AppDelegate.objectConfigration centerViewController];
    self.leftViewController = [AppDelegate.objectConfigration lelftViewController];
    self.rightViewController = [AppDelegate.objectConfigration rightViewController];
    //self.bottomViewController = [[woBottomViewController alloc]init];
    [[UIApplication sharedApplication]   registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.swipeDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
     
    // Dispose of any resources that can be recreated.
}
-(void)resetView{
    [super resetView];
}
- (void)swipeController:(RNSwipeViewController *)swipeController willShowController:(UIViewController *)controller {
    NSLog(@"will show");
}

- (void)swipeController:(RNSwipeViewController *)swipeController didShowController:(UIViewController *)controller {
    NSLog(@"did show");
}
@end
