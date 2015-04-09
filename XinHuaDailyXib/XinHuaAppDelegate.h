//
//  XinHuaAppDelegate.h
//  XinHuaDailyXib
//
//  Created by zhang jun on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"
#import "DrawerViewController.h"
#import "Service.h"
#import <Frontia/Frontia.h>
@interface XinHuaAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)Service *service;
@property(strong,nonatomic)UserDefaults *user_defaults;
@property(nonatomic,strong)DrawerViewController *main_vc;
@property(nonatomic,strong)UIAlertView *prepare_error_alert;
@property(nonatomic,strong)UIAlertView *push_article_alert;
@property(nonatomic,strong)FrontiaShare *share;
@property (nonatomic,assign)BOOL is_full;


@end
