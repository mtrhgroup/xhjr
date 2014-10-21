//
//  ChannelViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/14.
//
//

#import "ChannelViewController.h"
#import "AuthorizationCoverView.h"
#import "NavigationController.h"
#import "Service.h"
@interface ChannelViewController ()
@property(nonatomic,strong)AuthorizationCoverView *authorization_cover_view;
@end

@implementation ChannelViewController
@synthesize channel=_channel;
@synthesize authorization_cover_view=_authorization_cover_view;
@synthesize service=_service;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.channel.channel_name;
    [self buildUI];
    _authorization_cover_view=[[AuthorizationCoverView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_authorization_cover_view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoverView) name:@"" object:nil];
    if(_channel.need_be_authorized){
        if([self authorize]){
            [self removeCoverView];
        }else{
            [self pushRegisterVC];
        }
    }

    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"title_menu_btn_normal.png"] target:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"nav_func.png"] target:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showLeftMenu{
    
}
-(void)showMenu{
    
}

-(void)buildUI{
    
}
-(BOOL)authorize{
    return [_service authorize];
}
-(void)removeCoverView{
    [_authorization_cover_view removeFromSuperview];
}
-(void)pushRegisterVC{
    
}
@end
