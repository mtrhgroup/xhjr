//
//  ChannelCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/21.
//
//

#import "ChannelCell.h"
#import "GridCell.h"
#import "GlobalVariablesDefine.h"
@implementation ChannelCell{
    MenuItem *_menu_item;
    UILabel *title_lbl;
    UIButton *close_btn;
    UIImageView *close_icon;
    UIView *accessoryView;
    UICollectionView *children_view;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title_lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 24)];
        [title_lbl setFont: [UIFont boldSystemFontOfSize:22]];
        title_lbl.textColor=[UIColor whiteColor];
        [[self contentView] addSubview:title_lbl];
        self.backgroundColor=[UIColor clearColor];
        self.accessoryType=UITableViewCellAccessoryNone;
        close_icon=[[UIImageView alloc] initWithFrame:CGRectMake(260-20-18, 11, 22, 22)];
        close_icon.image=[UIImage imageNamed:@"button_undo_default.png"];
        close_icon.hidden=YES;
        [self.contentView addSubview:close_icon];
        close_btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
        [close_btn addTarget:self action:@selector(closeFather) forControlEvents:UIControlEventTouchUpInside];
        close_btn.hidden=YES;
        [self.contentView addSubview:close_btn];
        UIView *white_line=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, 260, 1)];
        white_line.backgroundColor=HightLight_BG_COLOR;
        [self addSubview:white_line];
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(100, 44);
        flowLayout.minimumLineSpacing=0;
        flowLayout.minimumInteritemSpacing=0;
        children_view=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 40, 210, 200) collectionViewLayout:flowLayout];
        [children_view registerClass:[GridCell class] forCellWithReuseIdentifier:@"CellectionViewCellId"];
        children_view.dataSource=self;
        children_view.delegate=self;
        children_view.backgroundColor=[UIColor clearColor];
        [children_view reloadData];
        children_view.hidden=YES;
        [self.contentView addSubview:children_view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}
-(void)setMenu_item:(MenuItem *)menu_item{
    _menu_item=menu_item;
    children_view.hidden=YES;
    close_btn.hidden=YES;
    close_icon.hidden=YES;
    title_lbl.text=menu_item.display_name;
    self.backgroundColor=VC_BG_COLOR;
    if(menu_item.type==Item){
        title_lbl.textColor=[UIColor lightGrayColor];
        self.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_rightarrow_gray_default.png"]];
    }else if(menu_item.type==StandardChannelItem||menu_item.type==HomeChannelItem){
        title_lbl.textColor=[UIColor whiteColor];
        self.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_rightarrow_default.png"]];
    }else if(menu_item.type==FatherItem&&menu_item.father_is_open==NO){
        title_lbl.textColor=[UIColor whiteColor];
        self.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_more_default.png"]];
    }else if(menu_item.type==FatherItem&&menu_item.father_is_open==YES){
        title_lbl.textColor=[UIColor whiteColor];
        self.accessoryView=nil;
        close_icon.hidden=NO;
        close_btn.hidden=NO;
        children_view.frame=CGRectMake(10, 44, 210, [menu_item.childItem count]/2*48);
        children_view.hidden=NO;
        self.backgroundColor=HightLight_BG_COLOR;
    }
    if(menu_item.is_selected){
        title_lbl.textColor=[UIColor yellowColor];
    }
}
-(void)closeFather{
    _menu_item.father_is_open=NO;
    children_view.hidden=YES;
    [self.delegate fatherCloseBtnClicked];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate tagItemClickedWithTag:[self.menu_item.childItem objectAtIndex:indexPath.row]];
    
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.menu_item.childItem count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

static NSString *CellectionViewCellId=@"CellectionViewCellId";
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GridCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellectionViewCellId forIndexPath:indexPath];
    cell.tag=[self.menu_item.childItem objectAtIndex:indexPath.row];
    return cell;
}
+(CGFloat)preferHeightWithMenuItem:(MenuItem *)menu_item{
    if(menu_item.type==FatherItem&&menu_item.father_is_open==YES){
        return ([menu_item.childItem count]/2+1)*48;
    }else{
        return 44;
    }

}
@end
