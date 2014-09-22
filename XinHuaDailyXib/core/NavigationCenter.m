//
//  NavigationCenter.m
//  XinHuaDailyXib
//
//  Created by apple on 13-3-1.
//
//

#import "NavigationCenter.h"
#import "MainViewDataSource.h"
#import "SwipeViewController.h"
#import "NewsContentSource.h"
#import "PicturePlusViewController.h"
#import "ContactUsViewController.h"
#import "SettingViewController.h"
#import "FunctionSource.h"
#import "NewsDownloadTask.h"
#import "WelcomeViewController.h"
#import "AdvPageViewController.h"
#import "PushNewsViewController.h"

@implementation NavigationCenter{

}
@synthesize centerViewController=_centerViewController;
@synthesize leftViewController=_leftViewController;
@synthesize rightViewController=_rightViewController;
@synthesize mainViewController=_mainViewController;
@synthesize channelDataSource=_channelDataSource;
@synthesize newsheaderDataSource=_newsheaderDataSource;
@synthesize periodicalContentViewController=_periodicalContentViewController;
@synthesize instantContentViewController=_instantContentViewController;
@synthesize priceChartViewController=_priceChartViewController;
@synthesize pushCenterViewController=_pushCenterViewController;
- (id)init
{
    self = [super init];
    if (self) {
        [self registerNotifications];
    }
    return self;
}
-(void)registerNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCenterViewToMainChannelWithChannel:) name:MainChannelTableDidSelectNewsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCenterViewToNewsChannelWithChannel:) name:NewsChannelTableDidSelectNewsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChannelTimeStampWithChannel:) name:ChannelNewsUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChannelsWithChannel:) name:UpdateChannelsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftPanelNotification:) name:ShowLeftPanelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRightPanelNotification:) name:ShowRightPanelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateXdailylist:) name:XdailyChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPeriodicalNewsWithXdaily:) name:PeriodicalNewsHeaderSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showExpressNewsWithXdaily:) name:ExpressNewsHeaderSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPushPeriodicalNewsWithXdaily:) name:PushPeriodicalNewsHeaderSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPushExpressNewsWithXdaily:) name:PushExpressNewsHeaderSelectionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPictureNewsWithContentSource:) name:PictureNewsHeaderSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAboutScene) name:ShowAboutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFavorScene) name:ShowFavorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFeedBackScene) name:ShowFeedBackNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettingScene) name:ShowSettingsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdvPageScene) name:ShowAdvPageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPushNewsScene) name:ShowPushNewsNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:KUpdateWithMemory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterSystem) name:EnterSystemNotifiction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUserSNException:) name:NSSNExceptionNotification object:nil];

    
}
-(void)notifyUserSNException:(NSNotification *)notification{
     NSString *exceptionInfo=[notification object];
    if([exceptionInfo isEqualToString:@"OK"]){
        [[_centerViewController.viewControllers objectAtIndex:0] hideExceptionNotification];
    }else{
        [[_centerViewController.viewControllers objectAtIndex:0] showExceptionNotification:exceptionInfo];
    }
    
}
-(void)updateChannelsWithChannel:(NSNotification *)notification{
    [_leftViewController reloadChannels];
}
-(void)enterSystem{
   // [_leftViewController setChannelSource:_channelDataSource];
}
-(void)showLeftPanelNotification:(NSNotification *)notification{
    [_mainViewController showLeft];
}
-(void)showRightPanelNotification:(NSNotification *)notification{
    [_mainViewController showRight];
}

-(void)changeCenterViewToMainChannelWithChannel:(NSNotification *)notification{
    NewsChannel *channel=[notification object];
    _mainViewController.centerViewController=[self centerViewController];
    [_mainViewController resetView];
    _mainViewDataSource.channel=channel;
    [[_centerViewController.viewControllers objectAtIndex:0] setMainViewDataSourceAndLoadDataWith:_mainViewDataSource];
    [_centerViewController popToRootViewControllerAnimated:YES];
}

-(void)changeCenterViewToNewsChannelWithChannel:(NSNotification *)notification{
    NewsChannel *channel=[notification object];
    _mainViewController.centerViewController=[self centerViewController];
    [_mainViewController resetView];
    NewsheaderDataSource *dataSource=[[NewsheaderDataSource alloc]init];
    dataSource.channel=channel;
    [[_centerViewController.viewControllers objectAtIndex:0] setDataSourceAndLoadDataWith:dataSource];
    [_centerViewController popToRootViewControllerAnimated:YES];
}
-(void)updateData{
    [_mainViewDataSource reloadDataFromCoreData];
    [_newsheaderDataSource reloadDataFromCoreData];
    //[[_centerViewController.viewControllers objectAtIndex:0] reloadTable];
}
-(void)showAdvPageScene{
    AdvPageViewController *aController = [[AdvPageViewController alloc] init];
    [_centerViewController pushViewController:aController animated:YES];
}

-(void)showPeriodicalNewsWithXdaily:(NSNotification *)notification{
    NewsContentSource *contentSource=[notification object];
    NewsListPlusViewController *aController = [[NewsListPlusViewController alloc] init];
    aController.siblings=contentSource.siblings;
    aController.index=contentSource.index;
    aController.type=@"file";
    aController.baseURL=@"";
    aController.channel_title=contentSource.title;
    aController.item_title=contentSource.title;
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory object: self];
    [_centerViewController pushViewController:aController animated:YES];
}
-(void)showExpressNewsWithXdaily:(NSNotification *)notification{
    NewsContentSource *contentSource=[notification object];
    ExpressPlusViewController *aController = [[ExpressPlusViewController alloc] init];
    aController.siblings=contentSource.siblings;
    aController.index=contentSource.index;
    aController.type=@"file";
    aController.baseURL=@"";
    aController.channel_title=contentSource.title;
    [_centerViewController pushViewController:aController animated:YES];
}

-(void)showPushPeriodicalNewsWithXdaily:(NSNotification *)notification{
    NewsContentSource *contentSource=[notification object];
    NewsListPlusViewController *aController = [[NewsListPlusViewController alloc] init];
    aController.siblings=contentSource.siblings;
    aController.index=contentSource.index;
    aController.type=@"file";
    aController.baseURL=@"";
    aController.channel_title=contentSource.title;
    aController.item_title=contentSource.title;
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory object: self];
    [_pushCenterViewController pushViewController:aController animated:YES];
}
-(void)showPushExpressNewsWithXdaily:(NSNotification *)notification{
    NewsContentSource *contentSource=[notification object];
    ExpressPlusViewController *aController = [[ExpressPlusViewController alloc] init];
    aController.siblings=contentSource.siblings;
    aController.index=contentSource.index;
    aController.type=@"file";
    aController.baseURL=@"";
    aController.channel_title=contentSource.title;
    [_pushCenterViewController pushViewController:aController animated:YES];
}

-(void)showPictureNewsWithContentSource:(NSNotification *)notification{
    NewsContentSource *contentSource=[notification object];
    PicturePlusViewController *aController = [[PicturePlusViewController alloc] init];
    aController.siblings=contentSource.siblings;
    aController.baseURL=@"";
    aController.index=contentSource.index;
    aController.type=@"file";
    aController.channel_title=@"图片新闻";
    [_centerViewController pushViewController:aController animated:YES];
}
-(void)showFavorScene{
    FavorBoxViewController* fbv = [[FavorBoxViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:fbv];
    [_centerViewController presentViewController:nav animated:YES completion:nil];
}
-(void)showPushNewsScene{
    UINavigationController *navc=[[UINavigationController alloc] initWithRootViewController:[[PushNewsViewController alloc]init]];
    [_centerViewController presentViewController:navc animated:YES completion:nil];
}
-(void)showAboutScene{
    XDAboutViewController* about = [[XDAboutViewController alloc] init];
    about.mode=0;
    [_centerViewController presentViewController:about animated:YES completion:nil];
}
-(void)showSubscribeScene{
    SubscribeViewController* sub = [[SubscribeViewController alloc] init];
    UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:sub];
    [_centerViewController presentViewController:unc animated:YES completion:nil];
}

-(void)showFeedBackScene{
    ContactUsViewController* nbx = [[ContactUsViewController alloc] init];
    UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:nbx];
    nbx.mode=0;
    [_centerViewController presentViewController:unc animated:YES completion:nil];
}

-(void)showSettingScene{
    SettingViewController* svc = [[SettingViewController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:svc];
    [_centerViewController presentViewController:nav animated:YES completion:nil];
}
-(void)updateXdailylist:(NSNotification *)notification{
    [[_centerViewController.viewControllers objectAtIndex:0] reloadTable];
}

-(void)updateChannelTimeStampWithChannel:(NSNotification *)notification{
    NewsChannel *channel=[notification object];
    [_channelDataSource stampTimeOnChannel:channel];
}


@end
