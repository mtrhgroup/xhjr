//
//  NavigationCenter.h
//  XinHuaDailyXib
//
//  Created by apple on 13-3-1.
//
//

#import <Foundation/Foundation.h>
#import "SwipeViewController.h"
#import "woCenterViewController.h"
#import "woLeftViewController.h"
#import "woRightViewController.h"
#import "PeriodicalContentViewController.h"
#import "InstantContentViewController.h"
#import "MainViewDataSource.h"
#import "NewsheaderDataSource.h"
#import "ChannelDataSource.h"
#import "MDSlideNavigationViewController.h"
@interface NavigationCenter : NSObject
@property(weak,nonatomic)SwipeViewController *mainViewController;
@property(weak,nonatomic)MDSlideNavigationViewController *centerViewController;
@property(weak,nonatomic)woLeftViewController *leftViewController;
@property(weak,nonatomic)woRightViewController *rightViewController;
@property(weak,nonatomic)ChannelDataSource *channelDataSource;
@property(weak,nonatomic)MainViewDataSource *mainViewDataSource;
@property(weak,nonatomic)NewsheaderDataSource *newsheaderDataSource;
@property(weak,nonatomic)PeriodicalContentViewController *periodicalContentViewController;
@property(weak,nonatomic)InstantContentViewController *instantContentViewController;
@property(weak,nonatomic)UINavigationController *priceChartViewController;
@property(weak,nonatomic)UINavigationController *pushCenterViewController;
@end
