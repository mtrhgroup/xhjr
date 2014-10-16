#import "LeftMenuViewController.h"
#import "NavigationController.h"
#import "ListChannelViewController.h"
#import "GridChannelViewController.h"
#import "TileChannelViewController.h"
@interface LeftMenuViewController ()
@property(nonatomic,strong)NSMutableArray *leftChannelVCs;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)Service *service;
@end

@implementation LeftMenuViewController{

}
@synthesize leftChannelVCs;
@synthesize tableView;
@synthesize service;
#pragma mark - 控制器初始化方法
- (id)init
{
    self = [super init];
    if (self) {
        self.service=AppDelegate.service;
        self.leftChannelVCs=[[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - 控制器方法

#pragma mark - 视图加载方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    self.title_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width, 30)];
    self.title_label.textColor=[UIColor whiteColor];
    self.title_label.text=@"蓝天幼儿园";
    self.title_label.font = [UIFont fontWithName:@"Arial" size:20];
    self.title_label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.title_label];

    self.sub_title_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width, 20)];
    self.sub_title_label.textColor=[UIColor grayColor];
    self.sub_title_label.text=@"爱亲子";
    self.sub_title_label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.sub_title_label];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 80, 300, self.view.bounds.size.height-44)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:(51.0/255.0) alpha:1.0];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView setScrollEnabled:NO];
    [self.view addSubview:self.tableView];
    [self rebuildUI];
}
-(void)rebuildUI{
    [self.leftChannelVCs removeAllObjects];
    NSArray *leftChannels=[self.service fetchTrunkChannelsFromDB];
    for(Channel *channel in leftChannels){
        UINavigationController  *left_vc;
        if(channel.show_type==List){
            ListChannelViewController *ilvc=[[ListChannelViewController alloc] init];
            left_vc = [[NavigationController alloc] initWithRootViewController:ilvc];
        }else if(channel.show_type==Tile){
            TileChannelViewController *igvc=[[TileChannelViewController alloc]init];
            left_vc = [[NavigationController alloc] initWithRootViewController:igvc];
        }else if(channel.show_type==Grid){
            GridChannelViewController *igvc=[[GridChannelViewController alloc]init];
            left_vc = [[NavigationController alloc] initWithRootViewController:igvc];
        }
        [self.leftChannelVCs addObject:left_vc];
    }
    self.leftChannelVCs=[self wrapLeftChannels:self.leftChannelVCs];
    [self.tableView reloadData];
}
-(NSMutableArray *)wrapLeftChannels:(NSArray *)channels{
    return [AppDelegate.main_vc appendOriginalChannels:channels];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc= [self.leftChannelVCs objectAtIndex:indexPath.row];
    [AppDelegate.main_vc setCenterViewController:vc
                              withCloseAnimation:YES completion:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.leftChannelVCs count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = (int)indexPath.row;
    NSString *LeftSideCellId = @"LeftSideCellId";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LeftSideCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LeftSideCellId];
    }
    UIViewController *vc=[self.leftChannelVCs objectAtIndex:row];
    cell.textLabel.text=vc.title;
    [cell.textLabel setFont: [UIFont boldSystemFontOfSize:25]];
    if(row==0){
        cell.textLabel.text=@"首页";
    }
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    return  cell;
}


@end
