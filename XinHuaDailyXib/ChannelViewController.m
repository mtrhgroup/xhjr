//
//  ChannelViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/14.
//
//

#import "ChannelViewController.h"
#import "AuthorizationCoverView.h"
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
