//
//  CollectionViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import "GridChannelViewController.h"
#import "GlobalVariablesDefine.h"
#import "NavigationController.h"
#import "MJRefresh.h"
#import "GridCell.h"
@interface GridChannelViewController ()
@property(nonatomic,strong)ChannelHeader *headerView;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation GridChannelViewController{
    CGSize cell_size;
}
NSString *CellectionViewCellId = @"CellectionViewCellId";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)buildUI{
    [self calculateCellSize];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=cell_size;
    flowLayout.minimumLineSpacing=0;
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.headerReferenceSize=CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*0.618);
    if(![self.channel.parent_id isEqualToString:@"0"]){
        if(lessiOS7){
            self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-kHeightOfTopScrollView) collectionViewLayout:flowLayout];
        }else{
            self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-20-kHeightOfTopScrollView) collectionViewLayout:flowLayout];
        }
    }else{
        if(lessiOS7){
            self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
        }else{
            self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
        }
    }
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"title_menu_btn_normal.png"] target:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[GridCell class] forCellWithReuseIdentifier:@"CellectionViewCellId"];
    [self.collectionView registerClass:[ChannelHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    // 2.集成刷新控件
    [self.collectionView addHeaderWithTarget:self action:@selector(reloadArticlesFromNET)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreArticlesFromNET)];
}

-(void)showLeftMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)calculateCellSize{
    CGFloat width=self.view.bounds.size.width/2-20;
    CGFloat height=width*0.618+20;
    cell_size=CGSizeMake(width, height);
}

-(void)headerClicked:(Article *)article{
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
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
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Article * article = [self.articles_for_cvc.other_articles objectAtIndex:indexPath.row];
    [AppDelegate.main_vc presentArtilceContentVCWithArticle:article channel:self.channel];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
-(void)triggerRefresh{
    [self.collectionView headerBeginRefreshing];
}
-(void)endRefresh{
    [self refreshUI];
    [self.collectionView headerEndRefreshing];
}
-(void)refreshUI{
    [self.collectionView registerClass:[ChannelHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).headerReferenceSize=CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*0.618);
    [self.collectionView reloadData];
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.articles_for_cvc.other_articles count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview=nil;
    if(kind==UICollectionElementKindSectionHeader){
        ChannelHeader *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        if(self.articles_for_cvc.header_article!=nil){
            headerView.article=self.articles_for_cvc.header_article;
            headerView.delegate=self;
        }
        reusableview=headerView;
    }
    return reusableview;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GridCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellectionViewCellId forIndexPath:indexPath];
    cell.article=[self.articles_for_cvc.other_articles objectAtIndex:indexPath.row];
    return cell;
}

@end
