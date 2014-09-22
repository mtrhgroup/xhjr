//
//  ObjectConfigration.m
//  XinHuaDailyXib
//
//  Created by apple on 13-3-1.
//
//

#import "ObjectConfigration.h"
#import "SwipeViewController.h"
#import "woCenterViewController.h"
#import "woLeftViewController.h"
#import "woRightViewController.h"
#import "NavigationCenter.h"
#import "PeriodicalContentViewController.h"
#import "PushNewsViewController.h"


@implementation ObjectConfigration
@synthesize channelDataSource=_channelDataSource;
@synthesize mainViewController=_mainViewController;
@synthesize newsheaderDataSource=_newsheaderDataSource;
@synthesize centerViewController=_centerViewController;
@synthesize lelftViewController=_leftViewController;
@synthesize rightViewController=_rightViewController;
@synthesize navigationCenter=_navigationCenter;
@synthesize mainViewDataSource=_mainViewDataSource;
@synthesize pushNewsCenterViewController=_pushNewsCenterViewController;

- (id)init
{
    self = [super init];
    if (self) {
        _channelDataSource=[[ChannelDataSource alloc]init];
        _mainViewController=[[SwipeViewController alloc]init];
        _centerViewController=[[MDSlideNavigationViewController alloc]initWithRootViewController:[[woCenterViewController alloc]init]];
        _leftViewController=[[woLeftViewController alloc]init];
        _rightViewController=[[woRightViewController alloc]init];
        _mainViewDataSource=[[MainViewDataSource alloc]init];
        _newsheaderDataSource=[[NewsheaderDataSource alloc]init];
        _periodicalContentViewController=[[PeriodicalContentViewController alloc]init];
        _navigationCenter=[[NavigationCenter alloc]init];
        _mainViewDataSource.channel=_channelDataSource.aggr_channel;
        _pushNewsCenterViewController=[[UINavigationController alloc] initWithRootViewController:[[PushNewsViewController alloc]init]];
        [self config];
    }
    return self;
}
-(void)config{
    _navigationCenter.channelDataSource=[self channelDataSource];
    _navigationCenter.mainViewController=[self mainViewController];
    _navigationCenter.centerViewController=[self centerViewController];
    _navigationCenter.leftViewController=[self lelftViewController];
    _navigationCenter.rightViewController=[self rightViewController];
    _navigationCenter.mainViewDataSource=[self mainViewDataSource];
    _navigationCenter.newsheaderDataSource=[self newsheaderDataSource];
    _navigationCenter.periodicalContentViewController=[self periodicalContentViewController];
    _navigationCenter.instantContentViewController=[self instantContentViewController];
    _navigationCenter.pushCenterViewController=[self pushNewsCenterViewController];
    
}




@end
