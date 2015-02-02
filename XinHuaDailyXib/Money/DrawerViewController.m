//
//  SUNViewController.m
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-10-9.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import "DrawerViewController.h"
#import "NavigationController.h"
#import "MMDrawerVisualState.h"
#import "ArticleViewController.h"
#import "CollectorBoxViewController.h"
#import "SettingViewController.h"
#import "RightViewController.h"
#import "HomeViewController.h"
#import "DefaultView.h"
#import "LeftMenuViewController.h"
#import "FirstDailyViewController.h"
@interface DrawerViewController ()
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)   DefaultView *cover_view;
@property (nonatomic, strong)  UINavigationController *nav_slideswitch_vc;
@property (nonatomic, strong)  UINavigationController *nav_comm_vc;
@property (nonatomic,strong)   LeftMenuViewController *left_menu_vc;
@property(nonatomic,strong)    RightViewController *right_vc;
@property(nonatomic,strong)    HomeViewController *center_vc;
@end

@implementation DrawerViewController
@synthesize cover_view;
@synthesize service;
static const CGFloat kPublicLeftMenuWidth = 280.0f;
static const CGFloat kPublicRigtMenuWidth = 280.0f;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.service=AppDelegate.service;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cover_view=[[DefaultView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.cover_view];
    self.view.backgroundColor=[UIColor whiteColor];
    //初始化左侧菜单对象
    self.left_menu_vc= [[LeftMenuViewController alloc]init];
    NavigationController *nv=[[NavigationController alloc]initWithRootViewController:self.left_menu_vc.home_vc];
    [self setCenterViewController:nv];
    [self setLeftDrawerViewController:self.left_menu_vc];
    NavigationController *order_nv=[[NavigationController alloc]initWithRootViewController:AppDelegate.order_vc];
    [self setRightDrawerViewController:order_nv];
    [self setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
    [self setMaximumRightDrawerWidth:kPublicRigtMenuWidth];
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(drawerController, drawerSide, percentVisible);
    }];
}

-(void)presentArticleContentVCWithPushArticleID:(NSString *)articleID{
    ArticleViewController *controller=[[ArticleViewController alloc] initWithPushArticleID:articleID];
    UINavigationController  *nav_vc = [[NavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav_vc animated:YES completion:nil];
}
-(void)presentArtilceContentVCWithArticle:(Article *)article channel:(Channel *)channel{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    ArticleViewController *controller=[[ArticleViewController alloc] initWithAritcle:article];
    UINavigationController  *nav_vc = [[NavigationController alloc] initWithRootViewController:controller];
    if(![channel.parent_id isEqualToString:@"0"]){
        [self presentViewController:nav_vc animated:NO completion:nil];
    }else{
        [self presentViewController:nav_vc animated:NO completion:nil];
    }
}

@end
