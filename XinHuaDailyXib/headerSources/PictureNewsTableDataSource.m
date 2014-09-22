//
//  PictureNewsTableDataSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import "PictureNewsTableDataSource.h"
#import "XDailyItem.h"
#import "PictureNews.h"
#import "PictureNewsBuilder.h"
#import "PictureView.h"
#import <QuartzCore/QuartzCore.h>

NSString *picturecellReuseIdentifier =@"picturenews";
@implementation PictureNewsTableDataSource{
    NSArray *_items;
}

-(void)setItems:(NSArray *)items{
    _items=[self xdailysToPictures:items];
}
-(NSArray *)xdailysToPictures:(NSArray *)items{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for(XDailyItem *item in items){
        [arr addObject:[PictureNewsBuilder picturenewsFromXDailyItem:item]];
    }
    return arr;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return [_items count];
}

-(PictureNews *)newsForIndexPath:(NSIndexPath *)indexPath{
    return [_items objectAtIndex:[indexPath row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:picturecellReuseIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:picturecellReuseIdentifier];
    }
    NSArray *views = [[cell contentView] subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    PictureNews *picturenews=[self newsForIndexPath:indexPath];
    NSString *title=picturenews.picture_title;
    if(indexPath.row==0){
        picturenews.picture_view.frame=CGRectMake(0, 0, 320, 200);
        [[cell contentView] addSubview:picturenews.picture_view];
        UIImageView* imv = [[UIImageView alloc] initWithFrame:CGRectMake(0,200-23 , 320 , 23)];
        imv.image = [UIImage imageNamed:@"heise.png"];
        UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 23)];
        labtext.backgroundColor = [UIColor clearColor];
        labtext.text = title;
        labtext.textColor = [UIColor whiteColor];
        labtext.font = [UIFont fontWithName:@"Arial" size:15];
        [imv addSubview:labtext];
        [[cell contentView] addSubview:imv];
    }else{
        picturenews.picture_view.frame=CGRectMake(5, 5, 64, 40);
        picturenews.picture_view.layer.cornerRadius = 5;
        picturenews.picture_view.layer.masksToBounds = YES;
        [[cell contentView] addSubview:picturenews.picture_view];
        UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 250, 50)];
        labtext.backgroundColor = [UIColor clearColor];
        labtext.text = title;
        labtext.font = [UIFont fontWithName:@"Arial" size:15];
        labtext.numberOfLines=2;
        [[cell contentView] addSubview:labtext];
        if(picturenews.isRead){
            labtext.textColor=[UIColor grayColor];
            picturenews.picture_view.grayStylable=YES;
            picturenews.picture_view.isGrayStyle=YES;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]==0){
        return 200;
    }else{
        return 50;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNotification *note=[NSNotification notificationWithName:PictureNewsTableDidSelectNewsNotification object:[self newsForIndexPath:indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

NSString *PictureNewsTableDidSelectNewsNotification=@"PictureNewsTableDidSelectNewsNotification";
@end
