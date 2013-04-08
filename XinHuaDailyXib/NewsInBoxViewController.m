//
//  NewsInBoxViewController.m
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsInBoxViewController.h"
#import "XdailyItem.h"
#import "XinHuaAppDelegate.h"
#import "NewsDbOperator.h"
#import "ExpressPlusViewController.h"
#import "NewsListPlusViewController.h"
#import "NewsChannel.h"
@interface NewsInBoxViewController ()

@end

@implementation NewsInBoxViewController

@synthesize xdailyitem_list=_xdailyitem_list;
@synthesize table;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:KUpdateInbox object:nil];
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_xdailyitem_list release];
    [table release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
//    UIView* booktopView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 832,640)];
//    booktopView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bigtablebg.png"]];
//    [self.view addSubview:booktopView];
//    [booktopView release];
    
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [butb release];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"收件箱";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    
    [self.view addSubview:bimgv];   
    [bimgv release];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    [table setSeparatorColor:[UIColor clearColor]];
    table.delegate =self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, 40,40)]; 
    UIImage *favor_image=[UIImage imageNamed:@"clip.png"];
    [favorBtn setImage:favor_image forState:UIControlStateNormal];
    [self.view addSubview:favorBtn];
    [favorBtn release];
     [self update];

}



-(void)backAction:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}
-(void)update{
    self.xdailyitem_list = [AppDelegate.db GetAllNewsSub];
    NSLog(@"xdailyitem_list count %d",[self.xdailyitem_list count]);
    [self.table reloadData];  
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_xdailyitem_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XdailyItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSArray *views = [cell subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    UIImageView *cellbackground_image=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cellbackground.png"]];
    cell.backgroundView = cellbackground_image;
    [cellbackground_image release];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redarrow.png"]];
    image.frame = CGRectMake(300, 15, 11, 12);
    [cell addSubview:image];
    [image release];
    
    
    if([self.xdailyitem_list count]>0){
    XDailyItem *itemAtIndex = [self.xdailyitem_list objectAtIndex:indexPath.row];
    if(!itemAtIndex.isRead){
        UIImageView* mv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 15, 15)];
        mv.image = [UIImage imageNamed:@"red.png"];
        [cell addSubview:mv];
        [mv release];
        UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
        labtext.backgroundColor = [UIColor clearColor];
        labtext.text = itemAtIndex.title;
        labtext.font = [UIFont fontWithName:@"system" size:15];
        labtext.textColor=[UIColor blackColor];
        [cell addSubview:labtext];
        [labtext release];
    }else{
        UIImageView* mv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 15, 15)];
        mv.image = [UIImage imageNamed:@"unread_dot.png"];
        [cell addSubview:mv];
        [mv release];
        UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
        labtext.backgroundColor = [UIColor clearColor];
        labtext.text = itemAtIndex.title;
        labtext.font = [UIFont fontWithName:@"system" size:15];
        labtext.textColor=[UIColor grayColor];
        [cell addSubview:labtext];
        [labtext release];
    }  
    }
    return cell;
}

#pragma mark - Table view delegate
-(NSString *)getExpressChannelID{
    NSMutableArray * channels=[AppDelegate.db allChannels];
    for(NewsChannel *channel in channels){
        if(channel.generate.intValue==1){
            return channel.channel_id;
        }
    }
    return @"";
}

-(BOOL)isExpressChannel:(NSString *)channel_id{
    NSMutableArray * channels=[AppDelegate.db allChannels];
    for(NewsChannel *channel in channels){
        if([channel_id isEqualToString:channel.channel_id] && channel.generate.intValue==1){
            return YES;
        }
    }
    return NO;
}
-(NSString *)getChannelIDWith:(NSString *)channel_id{
    NSMutableArray * channels=[AppDelegate.db allChannels];
    for(NewsChannel *channel in channels){
        if([channel_id isEqualToString:channel.channel_id]){
            return channel.title;
        }
    }
    return @"";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XDailyItem * daily = [self.xdailyitem_list objectAtIndex:[self.table indexPathForSelectedRow].row];
    NSLog(@"%@",daily.pageurl);
    NSLog(@"%@",daily.zipurl);
    daily.isRead  = YES;
    NSLog(@"   inbox  %@",daily.title);
    [AppDelegate.db ModifyDailyNews:daily];
    [AppDelegate.db SaveDb];

    NSMutableArray *xdailyitem_list= [AppDelegate.db GetNewsByChannelID:daily.channelId];
    
    if([self isExpressChannel:daily.channelId]){
        ExpressPlusViewController *aController = [[[ExpressPlusViewController alloc] init] autorelease]; 
        aController.type=@"file";  
        aController.siblings=xdailyitem_list;
        aController.index=[self getIndexFromArray:daily array:xdailyitem_list];
        NSLog(@"aController.index express %d",aController.index);
        aController.baseURL=@"";
        aController.channel_title=[self getChannelIDWith:daily.channelId];
        [self.navigationController pushViewController:aController animated:YES];
    }else{
        NewsListPlusViewController *aController = [[[NewsListPlusViewController alloc] init] autorelease]; 
        aController.type=@"file";  
        aController.siblings=xdailyitem_list;
        aController.index=[self getIndexFromArray:daily array:xdailyitem_list];
        NSLog(@"aController.index normal %d",aController.index);
        aController.baseURL=@"";
        aController.channel_title=[self getChannelIDWith:daily.channelId];;
        aController.item_title=[self getChannelIDWith:daily.channelId];
        [self.navigationController pushViewController:aController animated:YES];
    }
}
-(int)getIndexFromArray:(XDailyItem *)item array:(NSMutableArray *)array{
    for(int i=0;i<[array count];i++){
        XDailyItem *daily=[array objectAtIndex:i];
        if(daily.item_id.intValue ==item.item_id.intValue){
            return i;
        }
    }
    return 0;
    
}

@end
