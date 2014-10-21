//
//  SUNViewController.m
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-10-9.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import "DrawerViewController.h"
#import "NavigationController.h"
#import "TrunkChannelViewController.h"
#import "MMDrawerVisualState.h"
#import "ArticleViewController.h"
#import "CollectorBoxViewController.h"
#import "SettingViewController.h"
#import "RightViewController.h"
@interface DrawerViewController ()
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)DefaultView *cover_view;
@property (nonatomic, strong)  UINavigationController *nav_slideswitch_vc;
@property (nonatomic, strong)  UINavigationController *nav_comm_vc;
@property (nonatomic,strong)   LeftMenuViewController *left_menu_vc;
@property(nonatomic,strong)    RightViewController *right_vc;
@end

@implementation DrawerViewController
@synthesize cover_view;
@synthesize service;
static const CGFloat kPublicLeftMenuWidth = 240.0f;
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
    self.cover_view.delegate=self;
    TrunkChannelViewController *slideSwitchVC = [[TrunkChannelViewController alloc] init];
    self.nav_slideswitch_vc = [[NavigationController alloc] initWithRootViewController:slideSwitchVC];
    self.nav_slideswitch_vc.delegate=slideSwitchVC;
    //初始化左侧菜单对象
    self.left_menu_vc= [[LeftMenuViewController alloc]init];
    self.right_vc=[[RightViewController alloc] init];
    //    //初始化抽屉视图对象
    [self setCenterViewController:self.nav_slideswitch_vc];
    [self setLeftDrawerViewController:self.left_menu_vc];
    [self setRightDrawerViewController:self.right_vc];
    [self setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(drawerController, drawerSide, percentVisible);
    }];
    [self.service fetchChannelsFromNET:^(NSArray *channels) {
      //  <#code#>
    } errorHandler:^(NSError *error) {
      //  <#code#>
    }];
}
-(void)setTopTitle:(NSString *)title{
    [[self.nav_slideswitch_vc.viewControllers objectAtIndex:0] setTitle:title];
}
-(void)presentArticleContentVCWithPushArticleID:(NSString *)articleID{
    ArticleViewController *controller=[[ArticleViewController alloc] initWithPushArticleID:articleID];
    UINavigationController  *nav_vc = [[NavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav_vc animated:YES completion:nil];
}
-(void)presentArtilceContentVCWithArticle:(Article *)article channel:(Channel *)channel{
    ArticleViewController *controller=[[ArticleViewController alloc] initWithAritcle:article];
    UINavigationController  *nav_vc = [[NavigationController alloc] initWithRootViewController:controller];
    if(![channel.parent_id isEqualToString:@"0"]){
        [self.nav_slideswitch_vc presentViewController:nav_vc animated:YES completion:nil];
    }else{
        [self presentViewController:nav_vc animated:YES completion:nil];
    }
}


-(NSMutableArray *)appendOriginalChannels:(NSArray*)channels{
    NSMutableArray *originalChannels=[NSMutableArray arrayWithArray:channels];    
    Channel *defaultChannel=[[Channel alloc] init];
    defaultChannel.channel_name=@"首页";
    defaultChannel.channel_id=@"0";
    [originalChannels insertObject:self.nav_slideswitch_vc atIndex:0];
    return originalChannels;
}
-(void)loadDataForMainVC{
    [self.left_menu_vc rebuildUI];
    [((TrunkChannelViewController *)[[self.nav_slideswitch_vc viewControllers] objectAtIndex:0]) rebuildUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
