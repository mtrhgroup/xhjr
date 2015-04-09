//
//  LeftViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "LeftViewController.h"
#import "LeftFunctionCell.h"
#import "CollectorBoxViewController.h"
#import "RequestViewController.h"
#import "TagListViewController.h"
#import "NavigationController.h"
#import "TagCell.h"
#import "TagHeaderView.h"
#import "GlobalVariablesDefine.h"
@interface LeftViewController ()
@property(nonatomic,strong)UITableView *func_table;
@property(nonatomic,strong)UICollectionView *tag_collection;
@property(nonatomic,strong)NSArray *tags;
@end

@implementation LeftViewController
@synthesize func_table=_func_table;
@synthesize tag_collection=_tag_collection;
@synthesize tags=_tags;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=VC_BG_COLOR;
    self.tags=[self.service fetchLatestDailyTagsFromDBWithChannel:AppDelegate.channel];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing=10;
    flowLayout.minimumInteritemSpacing=5;
    flowLayout.headerReferenceSize=CGSizeMake(self.view.bounds.size.width, 44);
    self.tag_collection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, 240, self.view.bounds.size.height-44*3-20) collectionViewLayout:flowLayout];
    self.tag_collection.backgroundColor=[UIColor clearColor];
    [self.tag_collection registerClass:[TagCell class] forCellWithReuseIdentifier:@"CellectionViewCellId"];
    [self.tag_collection registerClass:[TagHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    self.tag_collection.dataSource=self;
    self.tag_collection.delegate=self;
    [self.view addSubview:self.tag_collection];
    UIView *black_line=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44*3-1, 240, 1)];
    black_line.backgroundColor=[UIColor grayColor];
    [self.view addSubview:black_line];
    self.func_table=[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44*3, 240, 44*3)];
    self.func_table.delegate=self;
    self.func_table.dataSource=self;
    self.func_table.backgroundColor=[UIColor clearColor];
    self.func_table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.func_table];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTagsFromDB) name:kNotificationLatestDailyReceived object:nil];
}
-(void)reloadTagsFromDB{
    self.tags=[self.service fetchLatestDailyTagsFromDBWithChannel:AppDelegate.channel];
    [self.tag_collection reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tag_str=[self.tags objectAtIndex:indexPath.row];
    NSLog(@"%f",[self sizeWithString:tag_str font:[UIFont fontWithName:@"System" size:17.0]].width);
    return CGSizeMake(105, 40);
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
    NSString *tag=[self.tags objectAtIndex:indexPath.row];
    TagListViewController *vc=[[TagListViewController alloc]init];
    vc.tag=tag;
    vc.service=self.service;
    NavigationController *nv=[[NavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:nil];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tags count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview=nil;
    if(kind==UICollectionElementKindSectionHeader){
        reusableview=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    }
    return reusableview;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellectionViewCellId = @"CellectionViewCellId";
    TagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellectionViewCellId forIndexPath:indexPath];
    cell.tag=[self.tags objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

#pragma mark --UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* str = @"cellid";
    LeftFunctionCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[LeftFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section==0){
        if (indexPath.row == 0){
            cell.icon_image=[UIImage imageNamed:@"button_Pointsubject_default.png"];
            cell.label_text=@"点题";
            
        }else if(indexPath.row == 1){
            cell.icon_image=[UIImage imageNamed:@"button_history_default.png"];
            cell.label_text=@"查看往期";
            
        }else if(indexPath.row == 2){
            cell.icon_image=[UIImage imageNamed:@"button_favorite_default.png"];
            cell.label_text=@"收藏夹";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if (indexPath.row == 0){
            RequestViewController *vc=[[RequestViewController alloc]init];
            NavigationController *nv=[[NavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nv animated:YES completion:nil];
        }else if(indexPath.row == 1){
            DatePickerViewController *vc=[[DatePickerViewController alloc]init];
            NavigationController *nv=[[NavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nv animated:YES completion:nil];
        }else if(indexPath.row ==2){
            CollectorBoxViewController *vc=[[CollectorBoxViewController alloc]init];
            NavigationController *nv=[[NavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nv animated:YES completion:nil];
        }
    }
}
-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font{
    return [string sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
}
@end
