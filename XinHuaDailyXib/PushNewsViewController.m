//
//  PushNewsViewController.m
//  XinHuaDailyXib
//
//  Created by 张健 on 14-3-7.
//
//

#import "PushNewsViewController.h"
#import "XdailyItemViewController.h"

#import "NewsListPlusViewController.h"
#import "XdailyItemOlderViewController.h"
#import "XinHuaAppDelegate.h"
#import "NewsDbOperator.h"
#import "XdailyItem.h"
#import "NewsChannel.h"
#import "NewsXmlParser.h"
#import "NewsDefine.h"
#import "ASIHTTPRequest.h"
#import "NSIks.h"
#import "NewsDownloadTask.h"
#import "ExpressPlusViewController.h"
#import "NSThread+detachNewThreadSelectorWithObjs.h"
#import "NewsContentSource.h"
@interface PushNewsViewController ()

@end
NSString *pushnewscellReuseIdentifier =@"pushnewscellReuseIdentifier";
@implementation PushNewsViewController
@synthesize xdailyitem_list=_xdailyitem_list;
@synthesize table;
@synthesize emptyinfo_label;
@synthesize channel_id=_channel_id;
@synthesize channel_title=_channel_title;
@synthesize channel=_channel;
BOOL _displayMode;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewDidLayoutSubviews {
    // only works for iOS 7+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        // snaps the view under the status bar (iOS 6 style)
        viewBounds.origin.y = topBarOffset*-1;
        
        // shrink the bounds of your view to compensate for the offset
        //viewBounds.size.height = viewBounds.size.height -20;
        self.view.bounds = viewBounds;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    UIView* booktopView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 832,640)];
    booktopView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bigtablebg.png"]];
    [self.view addSubview:booktopView];
    
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"ext_navbar.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"消息汇总";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    [bimgv addSubview:lab];

    [self.view addSubview:bimgv];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0)) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    self.xdailyitem_list=[AppDelegate.db GetPushNews];
    [table reloadData];
    
    [self setExtraCellHidden:self.table];
    
    
    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, 40,40)];
    UIImage *favor_image=[UIImage imageNamed:@"clip.png"];
    [favorBtn setImage:favor_image forState:UIControlStateNormal];
    [self.view addSubview:favorBtn];
    NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
    if(displayMode==nil||[displayMode isEqualToString:@"日间模式"]){
        self.view.backgroundColor = [UIColor whiteColor];
        table.backgroundColor= [UIColor whiteColor];
    }else{
        self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        table.backgroundColor= [UIColor colorWithRed:30.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.0];
    }
}

-(void)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.xdailyitem_list count];
}

-(XDailyItem *)newsForIndexPath:(NSIndexPath *)indexPath{
    return [self.xdailyitem_list objectAtIndex:[indexPath row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:pushnewscellReuseIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pushnewscellReuseIdentifier];
    }
    NSArray *views = [[cell contentView] subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    XDailyItem *item=[self newsForIndexPath:indexPath];
    PictureNews *pic_item=[PictureNewsBuilder picturenewsFromXDailyItem:item];
    pic_item.picture_view.frame=CGRectMake(5, 5, 60, 60);
    pic_item.picture_view.layer.cornerRadius = 5;
    pic_item.picture_view.layer.masksToBounds = YES;
    [[cell contentView] addSubview:pic_item.picture_view];
    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 250, 60)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = item.title;
    labtext.font = [UIFont fontWithName:@"Arial" size:15];
    labtext.numberOfLines=2;
    [[cell contentView] addSubview:labtext];
    if(item.isRead){
        labtext.textColor=[UIColor grayColor];
        
    }
    UILabel* dateStr = [[UILabel alloc] initWithFrame:CGRectMake(75, 40, 220, 40)];
    dateStr.backgroundColor = [UIColor clearColor];
    dateStr.text = item.dateString;
    NSLog(@"summary at cell%@",item.dateString);
    dateStr.font = [UIFont fontWithName:@"Arial" size:10];
    dateStr.numberOfLines=1;
    dateStr.textColor=[UIColor grayColor];
    [[cell contentView] addSubview:dateStr];
    
    UILabel* channelStr = [[UILabel alloc] initWithFrame:CGRectMake(220, 40, 220, 40)];
    channelStr.backgroundColor = [UIColor clearColor];
    channelStr.text = item.channelTitle;
    NSLog(@"summary at cell%@",item.channelTitle);
    channelStr.font = [UIFont fontWithName:@"Arial" size:10];
    channelStr.numberOfLines=1;
    channelStr.textColor=[UIColor grayColor];
    [[cell contentView] addSubview:channelStr];
    
    if(item.isRead){
        labtext.textColor=[UIColor grayColor];        
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}
-(BOOL)isPeriodiaclItem:(NewsChannel *)channel{
    XDailyItem *item=[self.xdailyitem_list objectAtIndex:0];
    NSLog(@"%@",[[item.localPath lastPathComponent] substringToIndex:5]);
    if([[[item.localPath lastPathComponent] substringToIndex:5]isEqualToString:@"index"]){
        return YES;
    }else{
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsContentSource *contentSource=[[NewsContentSource alloc]init];
    contentSource.title=@"消息汇总";
    contentSource.siblings=self.xdailyitem_list;
    contentSource.index=indexPath.row;
    NSLog(@"%@ %d",_channel.title,_channel.generate.intValue);
    if([self isPeriodiaclItem:_channel]){
        [self showPushPeriodicalNewsWithXdaily:contentSource];
    }else{
        [self showPushExpressNewsWithXdaily:contentSource];
    }
    
}
-(void)showPushPeriodicalNewsWithXdaily:(NewsContentSource *)contentSource{
    NewsListPlusViewController *aController = [[NewsListPlusViewController alloc] init];
    aController.siblings=contentSource.siblings;
    aController.index=contentSource.index;
    aController.type=@"file";
    aController.baseURL=@"";
    aController.channel_title=contentSource.title;
    aController.item_title=contentSource.title;
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory object: self];
    [self.navigationController pushViewController:aController animated:YES];
}
-(void)showPushExpressNewsWithXdaily:(NewsContentSource *)contentSource{
    ExpressPlusViewController *aController = [[ExpressPlusViewController alloc] init];
    aController.siblings=contentSource.siblings;
    aController.index=contentSource.index;
    aController.type=@"file";
    aController.baseURL=@"";
    aController.channel_title=contentSource.title;
    [self.navigationController pushViewController:aController animated:YES];
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

-(void)setExtraCellHidden:(UITableView *)tableview{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableview setTableFooterView:view];
}

-(void)showEmptyInfo{
    self.emptyinfo_label.hidden=NO;
}
-(void)makeEmptyInfo{
    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 100)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = @"无内容，可下拉更新";
    labtext.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    labtext.textAlignment=NSTextAlignmentCenter;
    labtext.textColor=[UIColor grayColor];
    labtext.backgroundColor = [UIColor clearColor];
    self.emptyinfo_label=labtext;
    self.emptyinfo_label.hidden=YES;
    [self.view addSubview:labtext];
}
-(void)hideEmptyInfo{
    self.emptyinfo_label.hidden=YES;
}
NSString *PushPeriodicalNewsHeaderSelectionNotification=@"PushPeriodicalNewsHeaderSelectionNotification";
NSString *PushExpressNewsHeaderSelectionNotification=@"PushExpressNewsHeaderSelectionNotification";
@end
