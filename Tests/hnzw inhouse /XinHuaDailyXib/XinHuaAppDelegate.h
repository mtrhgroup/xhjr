//
//  XinHuaAppDelegate.h
//  XinHuaDailyXib
//
//  Created by zhang jun on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewsDbOperator.h"
#import "XinHuaViewController.h"
#import "NewsDbOperator.h"
#import "WelcomeViewController.h"

@interface XinHuaAppDelegate : UIResponder <UIApplicationDelegate>
{
    NewsDbOperator *_db;
}

@property (strong, nonatomic) UIWindow *window;
@property(retain,nonatomic)UINavigationController *mainviewController;
@property(retain,nonatomic)WelcomeViewController *startviewController;

@property (strong,nonatomic) NewsDbOperator* db;
@property(nonatomic,copy)NSArray *channel_list_subscribe;
@property(nonatomic,copy)NSMutableArray *channel_list;
@property(nonatomic,strong)NSString *flag;
@property(nonatomic)BOOL isSuspended;
@end
