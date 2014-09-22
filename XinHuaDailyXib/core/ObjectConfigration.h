//
//  ObjectConfigration.h
//  XinHuaDailyXib
//
//  Created by apple on 13-3-1.
//
//

#import <Foundation/Foundation.h>
#import "ObjectConfigration.h"
#import "SwipeViewController.h"
#import "woCenterViewController.h"
#import "woLeftViewController.h"
#import "woRightViewController.h"
#import "NavigationCenter.h"
#import "PeriodicalContentViewController.h"
#import "InstantContentViewController.h"
#import "MainViewDataSource.h"
#import "NewsheaderDataSource.h"
#import "ChannelDataSource.h"
#import "MDSlideNavigationViewController.h"
@interface ObjectConfigration : NSObject
@property(strong,nonatomic)SwipeViewController *mainViewController;
@property(strong,nonatomic)MDSlideNavigationViewController *centerViewController;
@property(strong,nonatomic)woLeftViewController *lelftViewController;
@property(strong,nonatomic)woRightViewController *rightViewController;
@property(strong,nonatomic)ChannelDataSource *channelDataSource;
@property(strong,nonatomic)MainViewDataSource *mainViewDataSource;
@property(strong,nonatomic)NewsheaderDataSource *newsheaderDataSource;
@property(strong,nonatomic)PeriodicalContentViewController *periodicalContentViewController;
@property(strong,nonatomic)InstantContentViewController *instantContentViewController;
@property(strong,nonatomic)NavigationCenter *navigationCenter;
@property(strong,nonatomic)UINavigationController *pushNewsCenterViewController;
@end
