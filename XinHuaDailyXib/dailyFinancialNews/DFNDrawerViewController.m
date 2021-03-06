//
//  SUNViewController.m
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-10-9.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import "DFNDrawerViewController.h"
#import "NavigationController.h"
#import "TrunkChannelViewController.h"
#import "MMDrawerVisualState.h"
#import "ArticleViewController.h"
#import "CollectorBoxViewController.h"
#import "SettingViewController.h"
#import "RightViewController.h"
#import "HomeViewController.h"
#import "FirstDailyViewController.h"
#import "LeftViewController.h"
@interface DFNDrawerViewController ()
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)DFNDefaultView *cover_view;
@property (nonatomic, strong)  UINavigationController *nav_slideswitch_vc;
@property (nonatomic, strong)  UINavigationController *nav_comm_vc;
@property (nonatomic,strong)   LeftViewController *left_menu_vc;
@property(nonatomic,strong)    RightViewController *right_vc;
@property(nonatomic,strong)    FirstDailyViewController *center_vc;
@end

@implementation DFNDrawerViewController
@synthesize cover_view;
@synthesize service;
static const CGFloat kPublicLeftMenuWidth = 240.0f;
static const CGFloat kPublicRightMenuWidth = 240.0f;
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
    self.cover_view=[[DFNDefaultView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.cover_view];
    self.view.backgroundColor=[UIColor whiteColor];
    //初始化左侧菜单对象
    self.left_menu_vc= [[LeftViewController alloc]init];
    self.left_menu_vc.service=self.service;
    self.right_vc=[[RightViewController alloc] init];
    self.center_vc=[[FirstDailyViewController alloc] init];
    self.center_vc.service=self.service;
    //    //初始化抽屉视图对象

    NavigationController *nv=[[NavigationController alloc]initWithRootViewController:self.center_vc];
    [self setCenterViewController:nv];
    [self setLeftDrawerViewController:self.left_menu_vc];
    [self setRightDrawerViewController:self.right_vc];
    [self setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
    [self setMaximumRightDrawerWidth:kPublicRightMenuWidth];
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
        ArticleViewController *controller=[[ArticleViewController alloc] initWithAritcle:article];
        [((NavigationController *)self.centerViewController) pushViewController:controller animated:YES];
}

@end
