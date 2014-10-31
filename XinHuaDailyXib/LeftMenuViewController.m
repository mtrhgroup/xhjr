#import "LeftMenuViewController.h"
#import "NavigationController.h"
#import "ListChannelViewController.h"
#import "GridChannelViewController.h"
#import "TileChannelViewController.h"
#import "TrunkChannelViewController.h"
#import "HomeViewController.h"
#import "ChannelCell.h"
@interface LeftMenuViewController ()
@property(nonatomic,strong)NSMutableArray *leftChannelVCs;
@property(nonatomic,strong)NSArray *leftChannels;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)ChannelViewController *pic_vc;
@end

@implementation LeftMenuViewController{

}
@synthesize leftChannelVCs=_leftChannelVCs;
@synthesize tableView=_tableView;
@synthesize service=_service;
@synthesize home_vc=_home_vc;
@synthesize pic_vc=_pic_vc;
#pragma mark - 控制器初始化方法
- (id)init
{
    self = [super init];
    if (self) {
        self.service=AppDelegate.service;
        self.leftChannelVCs=[[NSMutableArray alloc] init];
        self.leftChannels=[[NSArray alloc]init];
        [self createHomeVC];
    }
    return self;
}
-(void)createHomeVC{
    Channel *homeChannel=[[Channel alloc] init];
    homeChannel.channel_name=@"首页";
    homeChannel.channel_id=@"0";
    homeChannel.need_be_authorized=NO;
    self.home_vc=[[HomeViewController alloc]init];
    self.home_vc.channel=homeChannel;
    self.home_vc.service=AppDelegate.service;
    [self.leftChannelVCs addObject:self.home_vc];
}
#pragma mark - 控制器方法

#pragma mark - 视图加载方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    self.title_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.view.bounds.size.width, 30)];
    self.title_label.textColor=[UIColor whiteColor];
    self.title_label.text=@"辽宁发布 新华";
    self.title_label.font = [UIFont fontWithName:@"Arial" size:20];
    self.title_label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.title_label];
//    self.sub_title_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.view.bounds.size.width, 30)];
//    self.sub_title_label.textColor=[UIColor whiteColor];
//    self.sub_title_label.text=@"辽宁发布 新华";
//    self.sub_title_label.font = [UIFont fontWithName:@"Arial" size:20];
//    self.sub_title_label.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:self.sub_title_label];

    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 80, 300, self.view.bounds.size.height-44)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:(51.0/255.0) alpha:1.0];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView setScrollEnabled:NO];
    [self.view addSubview:self.tableView];
    [self rebuildUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rebuildUI) name:kNotificationChannelsUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kNotificationLeftChannelsRefresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAppVersion) name:kNotificationAppVersionReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPicChannel:) name:kNotificationShowPicChannel object:nil];
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
-(void)updateAppVersion{
    self.title_label.text=AppDelegate.user_defaults.appInfo.groupTitle;
}
-(void)refreshUI{
    [self.tableView reloadData];
}
-(void)rebuildUI{
    self.leftChannels=[self.service fetchTrunkChannelsFromDB];
    while([self.leftChannelVCs count]>1){
        [self.leftChannelVCs removeLastObject];
    }
    NSString *pic_channel_id=@"";
    for(Channel *channel in self.leftChannels){
        ChannelViewController  *cvc;
        if(channel.is_leaf){
            if(channel.show_type==List){
                cvc=[[ListChannelViewController alloc] init];
                cvc.channel=channel;
            }else if(channel.show_type==Tile){
                cvc=[[TileChannelViewController alloc]init];
                cvc.channel=channel;
            }else if(channel.show_type==Grid){
                cvc=[[GridChannelViewController alloc]init];
                cvc.channel=channel;
            }
        }else{
            cvc=[[TrunkChannelViewController alloc]init];
            cvc.channel=channel;
        }

        cvc.service=AppDelegate.service;
        [self.leftChannelVCs addObject:cvc];
    }
    [self.tableView reloadData];
    for(ChannelViewController *vc in self.leftChannelVCs){
        if([vc.channel.channel_id isEqualToString:pic_channel_id]){
            self.pic_vc=vc;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelViewController *cvc= [self.leftChannelVCs objectAtIndex:indexPath.row];
    cvc.channel.access_timestamp=[_service markAccessTimeStampWithChannel:cvc.channel];
    [self.tableView reloadData];
    NavigationController *nv=[[NavigationController alloc]initWithRootViewController:cvc];
    [AppDelegate.main_vc setCenterViewController:nv
                              withCloseAnimation:YES completion:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.leftChannelVCs count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
NSString *LeftSideCellId = @"LeftSideCellId";
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:LeftSideCellId];
    if(cell==nil){
        cell=[[ChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LeftSideCellId];
    }
    ChannelViewController *vc=[self.leftChannelVCs objectAtIndex:indexPath.row];
    cell.channel=vc.channel;   
    return  cell;
}
-(void)showPicChannel:(NSNotification *)notification{
    Channel *channel=[notification object];
    ChannelViewController *pic_vc;
    for(ChannelViewController *cvc in self.leftChannelVCs){
        if([cvc.channel.channel_id isEqualToString:channel.channel_id]||[cvc.channel.channel_id isEqualToString:channel.parent_id]){
            pic_vc=cvc;
        }
    }
    pic_vc.channel.access_timestamp=[_service markAccessTimeStampWithChannel:pic_vc.channel];
    [self.tableView reloadData];
    NavigationController *nv=[[NavigationController alloc]initWithRootViewController:pic_vc];
    [AppDelegate.main_vc setCenterViewController:nv
                              withCloseAnimation:YES completion:nil];
}

@end
