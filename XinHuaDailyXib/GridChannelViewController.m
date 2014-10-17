//
//  CollectionViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import "GridChannelViewController.h"

@interface GridChannelViewController ()

@end

@implementation GridChannelViewController
NSString *CellectionViewCellId = @"CellectionViewCellId";

- (id)initWithChannel:(KidsChannel *)channel
{
    self = [super init];
    if (self) {
        _content_service=AppDelegate.content_service;
        _refresh_interval_minutes=5;
        _items=[[NSMutableArray alloc] init];
        _time_stamp=[NSDate distantPast];
        _channel=channel;
        self.title=channel.name;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    self.view.backgroundColor=[UIColor redColor];
    self.touchView=[[KidsTouchEnrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.touchView.delegate=self;
    [self.view addSubview:self.touchView];
}
- (void)setupTableView
{
    [self calculateCellSize];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=cell_size;
    flowLayout.minimumLineSpacing=0;
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.headerReferenceSize=CGSizeMake(320, 160);
    if(self.channel.show_location==Top)
        if(lessiOS7){
            self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-kHeightOfTopScrollView) collectionViewLayout:flowLayout];
        }else{
            self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-20-kHeightOfTopScrollView) collectionViewLayout:flowLayout];
        }
    
        else{
            if(lessiOS7){
                self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44) collectionViewLayout:flowLayout];
            }else{
                self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
            }
            
            [((KidsNavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"title_menu_btn_normal.png"] target:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
            
        }
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[KidsTileCell class] forCellWithReuseIdentifier:@"CellectionViewCellId"];
    [self.collectionView registerClass:[KidsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self reloadDataFromDB];
    // 2.集成刷新控件
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.collectionView addFooterWithTarget:self action:@selector(footerRefreshing)];
}
-(void)showLeftMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
#pragma mark 开始进入刷新状态
- (void)headerRefreshing
{
    [self reloadDataFromNET];
}

- (void)footerRefreshing
{
    [self  loadMoreData];
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.channel.auth_type==AuthorizationRequired){
        NSString *class_id=[_content_service fetchClassIDFromLocal];
        if([class_id isEqual:@"0"]){
            [self.touchView show];
        }else{
            [self.touchView hide];
        }
    }
    if(self.channel.show_location==Left)
        self.title=self.channel.nickname;
    else
        [AppDelegate.main_vc setTopTitle:self.channel.nickname];
    if([self isOld]){
        [self.collectionView headerBeginRefreshing];
    }
}
-(void)calculateCellSize{
    if(self.channel.show_count_in_row==0)self.channel.show_count_in_row=2;
    CGFloat width=self.view.bounds.size.width/self.channel.show_count_in_row;
    CGFloat height=width/4*3;
    cell_size=CGSizeMake(width, height);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KidsArticle * article = [self.items objectAtIndex:indexPath.row];
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
    
}
-(void)headerClicked:(KidsArticle *)article{
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
}

-(void)clicked{
    [AppDelegate.main_vc presentClassListVCWithChannel:self.channel];
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return cell_size;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KidsArticle * article = [self.items objectAtIndex:indexPath.row];
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
-(void)reloadDataFromDB{
    [_items removeAllObjects];
    _header_item=[_content_service fetchHeaderArticleWithChannel:self.channel];
    NSString *exceptID=@"";
    if(_header_item!=nil){
        exceptID=_header_item.article_id;
    }
    [_items addObjectsFromArray:[_content_service fetchArticlesWithChannel:self.channel exceptArticleID:exceptID topN:countPerPage*2]];
    [self.collectionView reloadData];
    
}
-(void)reloadDataFromNET{
    [_content_service fetchArticlesFromNETWithChannelID:self.channel.channel_id pageIndex:0 successHandler:^(NSArray *articles) {
        [self reloadDataFromDB];
        _time_stamp=[NSDate date];
        [self.collectionView headerEndRefreshing];
        [_content_service fetchToDeleteArtilceIDsWithChannelID:self.channel.channel_id succcessHander:^(BOOL hasDeleted) {
            if(hasDeleted){
                [self reloadDataFromDB];
            }
        } errorHandler:^(NSError *error) {
            //
        }];
    } errorHandler:^(NSError *error) {
        [self.collectionView headerEndRefreshing];
    }];
}
-(void)loadMoreData{
    int pageIndex=[self.items count]/countPerPage+1;
    if(_header_item!=nil){
        pageIndex=([self.items count]+1)/countPerPage+1;
    }
    [_content_service fetchArticlesFromNETWithChannelID:self.channel.channel_id pageIndex:pageIndex successHandler:^(NSArray *articles) {
        int topN=[self.items count]+countPerPage;
        [_items removeAllObjects];
        [_items addObjectsFromArray:[_content_service fetchArticlesWithChannel:self.channel exceptArticleID:self.header_item.article_id topN:topN]];
        [self.collectionView reloadData];
        [self.collectionView footerEndRefreshing];
    } errorHandler:^(NSError *error) {
        [self.collectionView footerEndRefreshing];
    }];
}
-(BOOL)isOld{
    NSDate *now=[NSDate date];
    NSTimeInterval date1=[now timeIntervalSinceReferenceDate];
    NSTimeInterval date2=[_time_stamp timeIntervalSinceReferenceDate];
    long interval=date1-date2;
    if(interval>_refresh_interval_minutes*60){
        return YES;
    }else{
        return NO;
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_items count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview=nil;
    if(kind==UICollectionElementKindSectionHeader){
        KidsHeaderView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        if(self.header_item!=nil){
            [headerView setArticle:self.header_item];
            headerView.delegate=self;
        }
        reusableview=headerView;
    }
    return reusableview;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KidsTileCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellectionViewCellId forIndexPath:indexPath];
    [cell setArticle:[_items objectAtIndex:indexPath.row]];
    return cell;
}

@end
