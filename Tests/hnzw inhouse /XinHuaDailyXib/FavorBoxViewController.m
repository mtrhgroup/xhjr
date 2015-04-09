//
//  FavorBoxViewController.m
//  XinHuaNewsIOS
//
//  Created by apple on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FavorBoxViewController.h"
#import "NewsDbOperator.h"
#import "XinHuaAppDelegate.h"
#import "NewsArticleViewController.h"
#import "NewsChannel.h"
#import "NewsFavorManager.h"
@interface FavorBoxViewController ()

@end

@implementation FavorBoxViewController
@synthesize favor_list=_favor_list;
@synthesize requestStr;
@synthesize titleCont;
@synthesize favorTitle;
@synthesize table;
@synthesize emptyinfo_view;


- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:KUpdateFavorList object:nil];
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [_favor_list release];
    [requestStr release];
    [titleCont release];
    [favorTitle release];
    [table release];
    [emptyinfo_view release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
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
    lab.text = @"我的收藏";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    
    UIButton *trashBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 0, 43,43)];     
    UIImage * trash_image=[UIImage imageNamed:@"EMPTY.png"];
    [trashBtn setImage:trash_image forState:UIControlStateNormal];
    [trashBtn  addTarget:self action:@selector(delAllFavors) forControlEvents:UIControlEventTouchUpInside];
    [bimgv addSubview:trashBtn];
    [trashBtn release];
    [self.view addSubview:bimgv];
    [bimgv release];
     [self update];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0)) style:UITableViewStylePlain];
    [table setSeparatorColor:[UIColor clearColor]];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [table release];


    [self setExtraCellHidden:self.table];

    
    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, 40,40)]; 
    UIImage *favor_image=[UIImage imageNamed:@"clip.png"];
    [favorBtn setImage:favor_image forState:UIControlStateNormal];
    [self.view addSubview:favorBtn];   
    [favorBtn release];
}

-(void)showEmptyInfo{
    self.emptyinfo_view.hidden=NO;
}
-(void)makeEmptyInfo{
    UIView *emptyView=[[UIView alloc]initWithFrame:CGRectMake(10, 60, 300, 390+(iPhone5?88:0))];
//    emptyView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"1.png"]];
    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 100)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = @"无收藏";
    labtext.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    labtext.textAlignment=UITextAlignmentCenter;
    labtext.textColor=[UIColor grayColor];
    labtext.backgroundColor = [UIColor clearColor];
    [emptyView addSubview:labtext];
    [labtext release];
    self.emptyinfo_view=emptyView;
    self.emptyinfo_view.hidden=YES;
    [self.view  addSubview:emptyView];
    [emptyView release];
}
-(void)hideEmptyInfo{
    self.emptyinfo_view.hidden=YES;
}
-(void)backAction:(id)sender{
     [self dismissModalViewControllerAnimated:YES];
}

-(NSString *)getChannelTitleWith:(NSString *)channel_id{
    NSMutableArray * channels=[AppDelegate.db allChannels];
    for(NewsChannel *channel in channels){
        if([channel_id isEqualToString:channel.channel_id]){
            return channel.title;
        }
    }
    return @"";
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
    // Return the number of rows in the section.
    return [self.titleCont count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
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
    NSLog(@"titleCon__%@",titleCont);
    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 26)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = [titleCont objectAtIndex:indexPath.row];
    labtext.font = [UIFont fontWithName:@"system" size:15];
    labtext.textColor=[UIColor blackColor];
    labtext.backgroundColor = [UIColor clearColor];
    [cell addSubview:labtext];
    [labtext release];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NewsArticleViewController *aController = [[NewsArticleViewController alloc] init];
    NSLog(@"requeststr__%@",requestStr);
    aController.siblings=requestStr;   
    NSLog(@"indexPath%d",indexPath.row);
    aController.index=indexPath.row;
    aController.type=@"file";
    aController.baseURL=@"";
    aController.channel_title=@"我的收藏";
    aController.item_title=@"我的收藏";
    [self.navigationController pushViewController:aController animated:YES];
    [aController release];
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{  
    return @"删除";  
}  

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self removeFavorWith:[titleCont objectAtIndex:indexPath.row]];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



#pragma mark - Table view delegate

-(void)delAllFavors{    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您确定删除所有收藏文件吗？" delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate=self;
    [alert show];    
  }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{    
    if (buttonIndex == 1) {         
        [[NewsFavorManager sharedInstance] removeAll];
        [self updateFavorList];
    }
}

-(void)removeFavorWith:(NSString *)title{
    [[NewsFavorManager sharedInstance] removeArticleWithTitle:title];
    [self updateFavorList];
}
-(void)updateFavorList{
    self.titleCont=nil;
    self.titleCont=[[NewsFavorManager sharedInstance] allArticleTitle];
    self.requestStr=nil;
    self.requestStr = [[NewsFavorManager sharedInstance] allArticleURL];
    if([titleCont count]>0){
        [self hideEmptyInfo];
    }else{
        [self showEmptyInfo];
    }
    [self.table reloadData];
}
-(void)setExtraCellHidden:(UITableView *)tableview{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableview setTableFooterView:view];
    [view release];       
}
-(void)update{
    [self updateFavorList];
}
@end
