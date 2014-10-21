
#import "TrunkChannelViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ListChannelViewController.h"
#import "GridChannelViewController.h"
#import "TileChannelViewController.h"
#import "NavigationController.h"
@interface TrunkChannelViewController ()
@property (nonatomic, strong) SUNSlideSwitchView *slideSwitchView;
@property(nonatomic,strong)NSMutableArray *topChannelVCs;
@property(nonatomic,strong)UIViewController *currentVC;
@end

@implementation TrunkChannelViewController
@synthesize slideSwitchView=_slideSwitchView;
@synthesize topChannelVCs=_topChannelVCs;
@synthesize currentVC=_currentVC;
- (id)init
{
    self = [super init];
    if (self) {
        self.service=AppDelegate.service;
        self.topChannelVCs=[[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    //self.title = @"新华时讯通";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.slideSwitchView=[[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
    self.slideSwitchView.slideSwitchViewDelegate=self;
    [self.view addSubview:self.slideSwitchView];
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"000000"];
    self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"ff0000"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"custom_tab_indicator.png"]
                                        stretchableImageWithLeftCapWidth:66.0f topCapHeight:0.0f];
    
    
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
    rightSideButton.userInteractionEnabled = NO;
    self.slideSwitchView.rigthSideButton = rightSideButton;
    [self rebuildUI];
}
-(void)rebuildUI{
    [_topChannelVCs removeAllObjects];
    NSArray *leafChannels=[self.service fetchLeafChannelsFromDBWithTrunkChannel:self.channel];
    for(Channel *channel in leafChannels){
        ChannelViewController *cvc;
        if(channel.show_type==List){
            cvc=[[ListChannelViewController alloc] init];
            [_topChannelVCs addObject:cvc];
        }else if(channel.show_type==Grid){
            cvc=[[GridChannelViewController alloc] init];
            [_topChannelVCs addObject:cvc];
        }else if(channel.show_type==Tile){
            cvc=[[TileChannelViewController alloc] init];
            [_topChannelVCs addObject:cvc];
        }
        cvc.channel=channel;
        cvc.service=AppDelegate.service;
    }
    [self.slideSwitchView buildUI];
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([viewController isEqual:self]){
        [self.currentVC viewWillAppear:YES];
    }
}
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return [_topChannelVCs count];
}
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    UIViewController *currentVC=(UIViewController *)_topChannelVCs[number];
    return currentVC;
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    [AppDelegate.main_vc panGestureCallback:panParam];
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if([_topChannelVCs count]>0){
        self.currentVC=(UIViewController *)_topChannelVCs[number];
        [self.currentVC viewWillAppear:YES];
    }
}
@end
