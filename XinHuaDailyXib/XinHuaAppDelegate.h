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
#import "ObjectConfigration.h"

@interface XinHuaAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)UINavigationController *mainviewController;
@property(strong,nonatomic)WelcomeViewController *startviewController;
@property(strong,nonatomic)NSPersistentStoreCoordinator *storeCoordinater;
@property (strong,nonatomic) NewsDbOperator* db;
@property(nonatomic,strong)NSString *flag;
@property(nonatomic)BOOL isSuspended;
@property(strong,nonatomic)ObjectConfigration *objectConfigration;
@end
