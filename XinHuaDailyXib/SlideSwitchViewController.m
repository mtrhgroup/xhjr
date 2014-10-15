
#import "SlideSwitchViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ItemListViewController.h"
#import "ItemGridViewController.h"
#import "KidsNavigationController.h"
@interface SlideSwitchViewController ()
@property (nonatomic, strong) SUNSlideSwitchView *slideSwitchView;
@property(nonatomic,strong)NSMutableArray *topChannelVCs;
@property(nonatomic,strong)UIViewController *currentVC;
@property(nonatomic,strong)KidsService *service;
@end

@implementation SlideSwitchViewController
@synthesize slideSwitchView=_slideSwitchView;
- (id)init
{
    self = [super init];
    if (self) {
        self.service=AppDelegate.content_service;
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
    self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"ffffff"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"custom_tab_indicator.png"]
                                        stretchableImageWithLeftCapWidth:66.0f topCapHeight:0.0f];
    
    
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
    rightSideButton.userInteractionEnabled = NO;
    self.slideSwitchView.rigthSideButton = rightSideButton;
    
    [((KidsNavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"title_menu_btn_normal.png"] target:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self rebuildUI];
}
-(void)rebuildUI{
    [_topChannelVCs removeAllObjects];
    NSArray *topChannels=[self.service fetchTopChannelsFromDB];
    for(KidsChannel *channel in topChannels){
        if(channel.show_type==Detail){
            ItemListViewController *ilvc=[[ItemListViewController alloc] initWithChannel:channel];
            [_topChannelVCs addObject:ilvc];
        }else{
            ItemGridViewController *igvc=[[ItemGridViewController alloc]initWithChannel:channel];
            [_topChannelVCs addObject:igvc];
        }
        
    }
    [self.slideSwitchView buildUI];
}
-(void)showLeftMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
