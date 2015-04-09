//
//  AggregateChannelViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import "HomeViewController.h"
#import "ChannelHeader.h"
#import "ListFooterView.h"
#import "HomeCell.h"
#import "MJRefresh.h"
#import "NavigationController.h"
@interface HomeViewController ()
@property(nonatomic,strong)ChannelHeader *headerView;
@property(nonatomic,strong)ListFooterView *footerView;
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ArticlesForHVC *articles_for_hvc;
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)UIImageView *top_title;
@property(nonatomic,strong)TipTouchView *tip_view;
@property(nonatomic,assign)BOOL is_full_load;
@end

@implementation HomeViewController
@synthesize channel=_channel;
@synthesize service=_service;
@synthesize tableView=_tableView;
@synthesize headerView=_headerView;
@synthesize is_full_load=_is_full_load;
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:self.top_title];
    [self reloadArticlesFromDB];
    if(self.articles_for_hvc.is_empty){
        [self reloadArticlesFromNET];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.top_title removeFromSuperview];
    if([self.service hasAuthorized]){
        [self.tip_view hide];
    }else{
        [self.tip_view show];
    }
}
-(void)viewDidDisappear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.articles_for_hvc=[[ArticlesForHVC alloc] init];
    self.top_title=[[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-120)/2, 0, 120, 44)];
    self.top_title.image=[UIImage imageNamed:@"logo_top_subject.png"];
    self.tip_view=[[TipTouchView alloc] init];
    self.tip_view.delegate=self;
    [self.view addSubview:self.tip_view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newArticlesReceivedHandler) name:kNotificationNewArticlesReceived object:nil];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNewArticlesReceived object:nil];
}
-(void)buildUI{
    NSLog(@"%f",self.view.bounds.size.height);
    if(lessiOS7){
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    }else{
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-20)];
    }
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    self.footerView=[[ListFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.footerView.delegate=self;
    [self.view addSubview:self.tableView];
    [self.tableView addHeaderWithTarget:self action:@selector(reloadArticlesFromNET)];
    [self reloadArticlesFromNET];
}
BOOL _busy=NO;
-(void)reloadArticlesFromNET{
    [self.service fetchOceanHomeArticlesFromNETWithAritclesForHVC:self.articles_for_hvc successHandler:^(NSArray *articles) {
        [self reloadArticlesFromDB];
        [self.tableView headerEndRefreshing];
    } errorHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error.code==XBindingFailed){
                [self.tableView headerEndRefreshing];
                [self.tip_view show];
            }else{
                [self.tableView headerEndRefreshing];
               // [self.view.window showHUDWithText:error.localizedDescription Type:ShowPhotoNo Enabled:YES];
            }
        });
        
    }];
}

-(void)loadMoreArticlesFromNET{
    if([self.articles_for_hvc.other_articles count]==0)return;
    if(_busy)return;
    _busy=YES;
    [self.service fetchOceanHomeArticlesFromNETWithAritclesForHVC:self.articles_for_hvc successHandler:^(NSArray *articles) {
        self.articles_for_hvc=[self.service fetchOceanHomeArticlesFromDBWithTopN:[self.articles_for_hvc.other_articles count]+[articles count]];
        [self.tableView reloadData];
        [self endLoadingMore];
        _busy=NO;
    } errorHandler:^(NSError *error) {
        _busy=NO;
        [self endLoadingMore];
    }];
}
-(void)tipTouchViewClicked{
    RegisterViewController *reg_vc=[[RegisterViewController alloc] init];
    reg_vc.inside=YES;
    NavigationController *nav_vc=[[NavigationController alloc] initWithRootViewController:reg_vc];
    [self presentViewController:nav_vc animated:YES completion:nil];
}
-(void)newArticlesReceivedHandler{
    [self performSelectorOnMainThread:@selector(reloadArticlesFromDB) withObject:nil waitUntilDone:NO];
}
-(void)reloadArticlesFromDB{
    self.articles_for_hvc=nil;
    self.articles_for_hvc=[self.service fetchOceanHomeArticlesFromDBWithTopN:50];
    [self.tableView reloadData];
    
    if(self.articles_for_hvc.header_article!=nil){
        if(self.tableView.tableHeaderView==nil){
            ChannelHeader *header=[[ChannelHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width,300)];
            header.is_home_header=YES;
            header.article=self.articles_for_hvc.header_article;
            float height=[header preferHeight];
            header.frame=CGRectMake(0, 0, self.tableView.bounds.size.width, height);
            header.delegate=self;     
            self.tableView.tableHeaderView=header;
        }
    }else{
        self.tableView.tableHeaderView=nil;
    }
}

NSString *HomeListCellID = @"HomeListCellID";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell=nil;
    cell = [tableView dequeueReusableCellWithIdentifier:HomeListCellID];
    if(cell==nil){
        cell=[[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeListCellID];
    }
    Article *article=[self.articles_for_hvc.other_articles objectAtIndex:indexPath.row];
    cell.article=article;
    return (UITableViewCell *)cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return [self.articles_for_hvc.other_articles  count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HomeCell preferHeight] ;
}

-(void)clicked{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article *article = [self.articles_for_hvc.other_articles objectAtIndex:indexPath.row];
    
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row==[self.articles_for_hvc.other_articles count]-1){
//        if([self.articles_for_hvc.other_articles count]>=10&&[self.articles_for_hvc.other_articles count]<50){
//            [self beginLoadingMore];
//        }else{
//            [self endLoadingMore];
//        }
//    }
}
-(void)triggerRefresh{
    [self reloadArticlesFromNET];
}
-(void)headerClicked:(Article *)article{
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
}
-(void)beginLoadingMore{
    self.tableView.tableFooterView = self.footerView;
    self.footerView.state=Busy;
    [self loadMoreArticlesFromNET];
}
-(void)endLoadingMore{
    self.tableView.tableFooterView = self.footerView;
    self.footerView.state=Idle;
}
-(void)removeLoadingFooter{
    self.tableView.tableFooterView=nil;
}
@end
