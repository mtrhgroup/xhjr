//
//  ChannelViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/14.
//
//

#import "ChannelViewController.h"
#import "AuthorizationTouchView.h"
#import "NavigationController.h"
#import "RegisterViewController.h"
#import "Service.h"
@interface ChannelViewController ()
@property(nonatomic,strong)AuthorizationTouchView *authorization_cover_view;
@end

@implementation ChannelViewController
@synthesize channel=_channel;
@synthesize authorization_cover_view=_authorization_cover_view;
@synthesize service=_service;
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChannelNewArticlesStamp:) name:kNotificationNewArticlesReceived object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoverView) name:kNotificationBindSNSuccess object:nil];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNewArticlesReceived object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBindSNSuccess object:nil];
    
}
-(void)updateChannelNewArticlesStamp:(NSNotification *)notification{
//    NSString *channel_id=[notification object];
//    if([channel_id isEqualToString:self.channel.channel_id]){
//        self.channel.receive_new_articles_timestamp=[[notification userInfo] valueForKey:@"timestamp"];
//        if(self.channel.has_new_articles){
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLeftChannelsRefresh object:nil];
//        }
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.channel.channel_name;
    self.view.backgroundColor=[UIColor whiteColor];
    [self buildUI];
    _authorization_cover_view=[[AuthorizationTouchView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _authorization_cover_view.delegate=self;
    [self.view addSubview:_authorization_cover_view];
    
    if(_channel.need_be_authorized){
        if([self.service hasAuthorized]){
            [_authorization_cover_view hide];
        }else{
            [_authorization_cover_view show];
        }
    }

    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_menu_default.png"] target:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"button_order_default.png"] target:self action:@selector(showRightMenu) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showLeftMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)showRightMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
-(void)showMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)buildUI{
    
}
-(void)removeCoverView{
    [_authorization_cover_view hide];
}
-(void)touchViewClicked{
    [self pushRegisterVC];
}
-(void)pushRegisterVC{
//    RegisterViewController *vc=[[RegisterViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}
@end
