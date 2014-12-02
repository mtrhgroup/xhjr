#import "LeftMenuViewController.h"
#import "NavigationController.h"
#import "ListChannelViewController.h"
#import "GridChannelViewController.h"
#import "TileChannelViewController.h"
#import "TrunkChannelViewController.h"
#import "HomeViewController.h"
#import "ChannelCell.h"
#import "GlobalVariablesDefine.h"
#import "TagListViewController.h"
#import "SettingViewController.h"
#import "ContactUsViewController.h"
#import "AboutViewController.h"
#import "MenuItem.h"
@interface LeftMenuViewController ()
@property(nonatomic,strong)UIImageView *left_logo;
@property(nonatomic,strong)NSMutableArray *menu_items;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)ChannelViewController *pic_vc;
@property(nonatomic,strong)SettingViewController *setting_vc;
@property(nonatomic,strong)ContactUsViewController *feedback_vc;
@property(nonatomic,strong)AboutViewController *about_vc;

@end

@implementation LeftMenuViewController{

}
@synthesize left_logo=_left_logo;
@synthesize tableView=_tableView;
@synthesize service=_service;
@synthesize home_vc=_home_vc;
@synthesize setting_vc=_setting_vc;
@synthesize feedback_vc=_feedback_vc;
@synthesize pic_vc=_pic_vc;
#pragma mark - 控制器初始化方法
- (id)init
{
    self = [super init];
    if (self) {
        self.service=AppDelegate.service;
        self.menu_items=[[NSMutableArray alloc]init];
         [self createHomeVC];
    }
    return self;
}

-(void)createHomeVC{
    Channel *homeChannel=[[Channel alloc] init];
    homeChannel.channel_name=@"";
    homeChannel.channel_id=@"0";
    homeChannel.need_be_authorized=NO;
    self.home_vc=[[HomeViewController alloc]init];
    self.home_vc.channel=homeChannel;
    self.home_vc.service=AppDelegate.service;
    MenuItem *item=[[MenuItem alloc] init];
    item.display_name=@"首页";
    item.type=HomeChannelItem;
    item.vc=self.home_vc;
    [self.menu_items addObject:item];
}
-(void)createFeedBackVC{
    self.feedback_vc=[[ContactUsViewController alloc] init];
}
-(void)createAboutVC{
    self.about_vc=[[AboutViewController alloc] init];
}
#pragma mark - 控制器方法

#pragma mark - 视图加载方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *top_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    top_view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:top_view];
    self.left_logo=[[UIImageView alloc] initWithFrame:CGRectMake((240-200)/2, (150-58)/2+10, 200, 58)];
    self.left_logo.image=[UIImage imageNamed:@"logo_left_page_top.png"];
    [self.view addSubview:self.left_logo];


    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, top_view.frame.origin.y+top_view.frame.size.height, 260, self.view.bounds.size.height-(top_view.frame.origin.y+top_view.frame.size.height))];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= VC_BG_COLOR;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    [self rebuildUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rebuildUI) name:kNotificationChannelsReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kNotificationLeftChannelsRefresh object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationChannelsReceived object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLeftChannelsRefresh object:nil];
}
-(void)updateAppVersion{
    self.title_label.text=AppDelegate.user_defaults.appInfo.groupTitle;
}
-(void)refreshUI{
    [self.tableView reloadData];
}
-(void)rebuildUI{
    while([self.menu_items count]>1){
        [self.menu_items removeLastObject];
    }
    //add standard channel items
    NSArray *channels=[self.service fetchTrunkChannelsFromDB];
    for (Channel * channel in channels) {
        MenuItem *item=[[MenuItem alloc] init];
        item.display_name=channel.channel_name;
        item.type=StandardChannelItem;
        ListChannelViewController *cvc=[[ListChannelViewController alloc] init];
        cvc.channel=channel;
        cvc.service=AppDelegate.service;
        item.vc=cvc;
        [self.menu_items addObject:item];
    }
    //add father item
    MenuItem *discovery_item=[[MenuItem alloc] init];
    discovery_item.display_name=@"发现";
    discovery_item.type=FatherItem;
    discovery_item.childItem=[NSArray arrayWithObjects:@"宏观",@"政策",@"资源",@"贸易",@"金融",@"科技",@"权益",@"文化", nil];
    [self.menu_items addObject:discovery_item];
    
    //add items
    MenuItem *setting_item=[[MenuItem alloc] init];
    setting_item.display_name=@"设置";
    setting_item.type=Item;
    setting_item.vc=[[SettingViewController alloc] init];
    [self.menu_items addObject:setting_item];
    
    MenuItem *feedback_item=[[MenuItem alloc] init];
    feedback_item.display_name=@"意见反馈";
    feedback_item.type=Item;
    feedback_item.vc=[[ContactUsViewController alloc] init];
    [self.menu_items addObject:feedback_item];
    
    MenuItem *about_item=[[MenuItem alloc] init];
    about_item.display_name=@"关于我们";
    about_item.type=Item;
    about_item.vc=[[AboutViewController alloc] init];
    [self.menu_items addObject:about_item];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuItem *item= [self.menu_items objectAtIndex:indexPath.row];
    if(item.type==Item){
        NavigationController *nv=[[NavigationController alloc] initWithRootViewController:item.vc];
        [self presentViewController:nv animated:YES completion:nil];
    }else if(item.type==FatherItem){
        if(item.father_is_open==NO){
            item.father_is_open=YES;
        }
    }else if(item.type==HomeChannelItem||item.type==StandardChannelItem){
        NavigationController *nv=[[NavigationController alloc] initWithRootViewController:item.vc];
        [AppDelegate.main_vc setCenterViewController:nv withCloseAnimation:YES completion:nil];
    }
    [self.tableView reloadData];
    
}
-(void)pushVC{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menu_items count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item=[self.menu_items objectAtIndex:indexPath.row];
    return [ChannelCell preferHeightWithMenuItem:item];
    
}
NSString *LeftSideCellId = @"LeftSideCellId";
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:LeftSideCellId];
    if(cell==nil){
        cell=[[ChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LeftSideCellId];
    }
    MenuItem *item=[self.menu_items objectAtIndex:indexPath.row];
    cell.menu_item=item;
    cell.delegate=self;
    return  cell;
}
-(void)tagItemClickedWithTag:(NSString *)tag{
    NSLog(@"%@",tag);
    TagListViewController *tag_vc=[[TagListViewController alloc] init];
    tag_vc.service=AppDelegate.service;
    tag_vc.tag=tag;
    NavigationController *nv=[[NavigationController alloc] initWithRootViewController:tag_vc];
    [AppDelegate.main_vc setCenterViewController:nv withCloseAnimation:YES completion:nil];
}
-(void)fatherCloseBtnClicked{
    [self.tableView reloadData];
}

@end
