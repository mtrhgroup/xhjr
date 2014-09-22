//
//  ChannelDataSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-3-22.
//
//

#import "ChannelDataSource.h"
#import "NewsChannel.h"
#import "CommonMethod.h"
#import "Colors.h"
#define HEADER_COLOR	 [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0]
NSString *ChannelcellReuseIdentifier =@"ChannelCell";
@implementation ChannelDataSource{
    NSArray *_items;
}
@synthesize channelheanderText=_channelheanderText;
@synthesize aggr_channel=_aggr_channel;
- (id)init
{
    self = [super init];
    if (self) {
        _aggr_channel=[[NewsChannel alloc]init];
        Colors *colors=[[Colors alloc]init];
        _aggr_channel.channel_id=@"0";
        _aggr_channel.title=@"首页";
        _aggr_channel.color=[colors getAggrColor];
        _aggr_channel.imgArrow=[colors getAggrImage];
    }
    return self;
}
-(void)setItems:(NSArray *)items{
    NSMutableArray *tmpItems=[NSMutableArray arrayWithArray:items];
    [tmpItems insertObject:_aggr_channel atIndex:0];
    _items=tmpItems;
}
-(NSArray *)getItems{
    return _items;
}

-(void)stampTimeOnChannel:(NewsChannel *)channel{
    for(NewsChannel *item in _items){
        if([item.channel_id isEqualToString:channel.channel_id ]){
            [item stampTime];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

-(NewsChannel *)newsForIndexPath:(NSIndexPath *)indexPath{
    return [_items objectAtIndex:[indexPath row]];
}

-(NewsChannel *)getAggChannel{
    return [_items objectAtIndex:0];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ChannelcellReuseIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChannelcellReuseIdentifier];
    }
    NSArray *views = [[cell contentView] subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    NewsChannel *channel=[self newsForIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    

    UIView *colorBar=[[UIView alloc]initWithFrame:CGRectMake(2,1,5,41)];
    [colorBar setBackgroundColor:channel.color];
    [[cell contentView] addSubview:colorBar];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    UIImage *image=[self drawView:[cell contentView]];
     UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame=cell.frame;
    NSLog(@"%@",imageView);
//#ifdef LNZW
//    cell.selectedBackgroundView= imageView;
//#endif
    NSString *title=channel.title;
    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 250, 30)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = title;
    labtext.textColor=[UIColor blackColor];
    labtext.font = [UIFont fontWithName:@"Arial" size:17];
    [[cell contentView] addSubview:labtext];
    return cell;
}

- (UIImage *) drawView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [self postDidSelectRowNotificationWith:indexPath]; 
}
-(void)postDidSelectRowNotificationWith:(NSIndexPath *)indexPath{
    NewsChannel *channel=[self newsForIndexPath:indexPath];
    if([channel.channel_id isEqualToString:@"0"]){
        NSNotification *note=[NSNotification notificationWithName:MainChannelTableDidSelectNewsNotification object:channel];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }else{
        NSNotification *note=[NSNotification notificationWithName:NewsChannelTableDidSelectNewsNotification object:channel];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }

}

NSString *MainChannelTableDidSelectNewsNotification=@"MainChannelTableDidSelectNewsNotification";
NSString *NewsChannelTableDidSelectNewsNotification=@"NewsChannelTableDidSelectNewsNotification";
@end
