//
//  SUNViewController.m
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-10-9.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import "DrawerViewController.h"
#import "KidsOnlineADViewController.h"
#import "KidsNavigationController.h"
#import "SlideSwitchViewController.h"
#import "MMDrawerVisualState.h"
#import "KidsContentViewController.h"
#import "KidsClassListViewController.h"
#import "KidsFavorViewController.h"
#import "KidsSettingViewController.h"
@interface DrawerViewController ()
@property(nonatomic,strong)KidsService *service;
@property(nonatomic,strong)KidsDefaultView *cover_view;
@property (nonatomic, strong)  UINavigationController *nav_slideswitch_vc;
@property (nonatomic, strong)  UINavigationController *nav_comm_vc;
@property (nonatomic,strong)   LeftMenuViewController *left_menu_vc;
@end

@implementation DrawerViewController
@synthesize cover_view;
@synthesize service;
static const CGFloat kPublicLeftMenuWidth = 240.0f;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.service=AppDelegate.content_service;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cover_view=[[KidsDefaultView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.cover_view];
    self.cover_view.delegate=self;
    SlideSwitchViewController *slideSwitchVC = [[SlideSwitchViewController alloc] init];
    self.nav_slideswitch_vc = [[KidsNavigationController alloc] initWithRootViewController:slideSwitchVC];
    self.nav_slideswitch_vc.delegate=slideSwitchVC;
    //初始化左侧菜单对象
    self.left_menu_vc= [[LeftMenuViewController alloc]init];
    //    //初始化抽屉视图对象
    [self setCenterViewController:self.nav_slideswitch_vc];
    [self setLeftDrawerViewController:self.left_menu_vc];
    [self setRightDrawerViewController:nil];
    [self setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(drawerController, drawerSide, percentVisible);
    }];
    
    [self.service fetchAppCoverImageFromNet:^(KidsAppCoverImage *img) {
        
    } errorHandler:^(NSError *error) {
        //
    }];
	
}
-(void)setTopTitle:(NSString *)title{
    [[self.nav_slideswitch_vc.viewControllers objectAtIndex:0] setTitle:title];
}
-(void)presentArticleContentVCWithPushArticleID:(NSString *)articleID{
    KidsContentViewController *controller=[[KidsContentViewController alloc] initWithPushArticleID:articleID];
    UINavigationController  *nav_vc = [[KidsNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav_vc animated:YES completion:nil];
}
-(void)presentArtilceContentVCWithArticle:(KidsArticle *)article channel:(KidsChannel *)channel{
    KidsContentViewController *controller=[[KidsContentViewController alloc] initWithAritcle:article];
    UINavigationController  *nav_vc = [[KidsNavigationController alloc] initWithRootViewController:controller];
    if(channel.show_location==Top){
        [self.nav_slideswitch_vc presentViewController:nav_vc animated:YES completion:nil];
    }else{
        [self presentViewController:nav_vc animated:YES completion:nil];
    }
}
-(void)presentClassListVCWithChannel:(KidsChannel *)channel{
    KidsClassListViewController *controller=[[KidsClassListViewController alloc] init];
    UINavigationController  *nav_vc = [[KidsNavigationController alloc] initWithRootViewController:controller];
    if(channel.show_location==Top){
        [self.nav_slideswitch_vc presentViewController:nav_vc animated:YES completion:nil];
    }else{
        [self presentViewController:nav_vc animated:YES completion:nil];
    }
}


-(NSMutableArray *)appendOriginalChannels:(NSArray*)channels{
    NSMutableArray *originalChannels=[NSMutableArray arrayWithArray:channels];
    
    KidsChannel *defaultChannel=[[KidsChannel alloc] init];
    defaultChannel.name=@"首页";
    defaultChannel.channel_id=@"0";
    [originalChannels insertObject:self.nav_slideswitch_vc atIndex:0];
    
    KidsChannel* notificationChannel=[self.service fetchNotificationChannelFromDB];
    if(notificationChannel!=nil){
        ItemListViewController *ilvc=[[ItemListViewController alloc] initWithChannel:notificationChannel];
        ilvc.title=notificationChannel.name;
        UINavigationController  *left_vc_notification = [[KidsNavigationController alloc] initWithRootViewController:ilvc];
        [originalChannels addObject:left_vc_notification];
    }
    
    KidsChannel *favorChannel=[[KidsChannel alloc]init];
    favorChannel.name=@"收藏";
    favorChannel.channel_id=@"favor";
    KidsFavorViewController *ilvc_favor=[[KidsFavorViewController alloc] init];
    ilvc_favor.title=favorChannel.name;
    UINavigationController  *left_vc_favor = [[KidsNavigationController alloc] initWithRootViewController:ilvc_favor];
    [originalChannels addObject:left_vc_favor];
    
    KidsChannel *settingChannel=[[KidsChannel alloc]init];
    settingChannel.name=@"设置";
    settingChannel.channel_id=@"settings";
    KidsSettingViewController *ilvc=[[KidsSettingViewController alloc] init];
    ilvc.title=settingChannel.name;
    UINavigationController  *left_vc = [[KidsNavigationController alloc] initWithRootViewController:ilvc];
    [originalChannels addObject:left_vc];
    return originalChannels;
}
-(void)loadDataForMainVC{
    [self.left_menu_vc rebuildUI];
    [((SlideSwitchViewController *)[[self.nav_slideswitch_vc viewControllers] objectAtIndex:0]) rebuildUI];
}
-(void)openADWithURL:(NSString *)url{
    KidsOnlineADViewController *controller=[[KidsOnlineADViewController alloc] init];
    controller.url=url;
    UINavigationController  *nav_vc = [[KidsNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav_vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
