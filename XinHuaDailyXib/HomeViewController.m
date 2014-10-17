//
//  AggregateChannelViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import "HomeViewController.h"
#import "HomeHeader.h"
#import "ListCell.h"
#import "MJRefresh.h"
@interface HomeViewController ()
@property(nonatomic,strong)HomeHeader *headerView;
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *channels;
@property(nonatomic,strong)Channel *pic_channel;
@property(nonatomic,strong)Service *service;
@end

@implementation HomeViewController
@synthesize service=_service;
@synthesize channels=_channels;
@synthesize pic_channel=_pic_channel;
@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
        if(lessiOS7){
            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-kHeightOfTopScrollView)];
        }else{
            self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-20-kHeightOfTopScrollView)];
        }
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.headerView=[[HomeHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 160)];
    self.headerView.articles=self.pic_channel.articles;
    self.headerView.delegate=self;
    [self.view addSubview:self.tableView];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadArticlesFromNET)];
}

NSString *ListCellID = @"ListCellID";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
    if(cell==nil){
        cell=[[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellID];
    }
    Channel *channel=[self.channels objectAtIndex:indexPath.section];
    Article *article = [channel.articles objectAtIndex:indexPath.row];
    cell.artilce=article;
    return (UITableViewCell *)cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(3, 1, 300, 18)];
    titleLabel.text=((Channel *)[self.channels objectAtIndex:section]).channel_name;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.channels count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return ((Channel *)[self.channels objectAtIndex:section]).channel_name;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return [((Channel *)[self.channels objectAtIndex:section]).articles count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(void)clicked{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Channel *channel=[self.channels objectAtIndex:indexPath.section];
    Article *article = [channel.articles objectAtIndex:indexPath.row];
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:channel];
}

-(void)reloadArticlesFromNET{
    [self.service  fetchHomeArticlesFromNET:^(NSArray *channels) {
        self.pic_channel=[channels firstObject];
        NSMutableArray *temp_channels=[NSMutableArray arrayWithArray:channels];
        [temp_channels removeLastObject];
        self.channels=temp_channels;
    } errorHandler:^(NSError *error) {
       // <#code#>
    }];
}
-(void)refreshUI{
    [self.tableView reloadData];
}
@end
