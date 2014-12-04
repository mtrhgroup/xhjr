//
//  DFNAppDelegate.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>


#import "Service.h"
#import <Frontia/Frontia.h>
#import "DrawerViewController.h"
#import "RegisterViewController.h"
#import "OrderViewController.h"
@interface MoneyAppDelegate : UIResponder<UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)Service *service;
@property(strong,nonatomic)Channel *channel;
@property(strong,nonatomic)UserDefaults *user_defaults;
@property(nonatomic,strong)DrawerViewController *main_vc;
@property(nonatomic,strong)OrderViewController *order_vc;
@property(nonatomic,strong)RegisterViewController *reg_vc;
@property(nonatomic,strong)UIAlertView *prepare_error_alert;
@property(nonatomic,strong)UIAlertView *push_article_alert;
@property(nonatomic,strong)FrontiaShare *share;
@property (nonatomic,assign)BOOL is_full;
@end
