//
//  InstantNewsDataSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-2-28.
//
//

#import "InstantNewsDataSource.h"
#import "XDailyItem.h"
@implementation InstantNewsDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    NSArray *views = [[cell contentView] subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    XDailyItem *periodicalnews=[self newsForIndexPath:indexPath];
//    UIView *btmLine=[[UIView alloc] initWithFrame:CGRectMake(5, 43, 290, 1)];
//    btmLine.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"list_diver.png"]];
//    [[cell contentView] addSubview:btmLine];
//    [btmLine release];
    
//    UIImageView *cellbackground_image=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cellbackground.png"]];
//    cell.backgroundView = cellbackground_image;
//    [cellbackground_image release];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redarrow.png"]];
    image.frame = CGRectMake(300, 19, 11, 12);
    [[cell contentView] addSubview:image];
    
    if(!periodicalnews.isRead){
        UIImageView* mv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 18, 15, 15)];
        mv.image = [UIImage imageNamed:@"red.png"];
        [[cell contentView] addSubview:mv];
        UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 260, 50)];
        labtext.backgroundColor = [UIColor clearColor];
        labtext.text = periodicalnews.title;
        labtext.font = [UIFont fontWithName:@"system" size:15];
        labtext.textColor=[UIColor blackColor];
        labtext.numberOfLines=2;
        [[cell contentView] addSubview:labtext];
    }else{
        UIImageView* mv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 18, 15, 15)];
        mv.image = [UIImage imageNamed:@"unread_dot.png"];
        [[cell contentView] addSubview:mv];
        
        UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 260, 50)];
        labtext.backgroundColor = [UIColor clearColor];
        labtext.text = periodicalnews.title;
        labtext.font = [UIFont fontWithName:@"system" size:15];
        labtext.textColor=[UIColor grayColor];
        [[cell contentView] addSubview:labtext];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNotification *note=[NSNotification notificationWithName:InstantNewsTableDidSelectNewsNotification object:[super newsForIndexPath:indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
NSString *InstantNewsTableDidSelectNewsNotification=@"InstantNewsTableDidSelectNewsNotification";

@end
