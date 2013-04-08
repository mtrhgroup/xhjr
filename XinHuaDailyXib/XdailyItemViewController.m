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
@interface XdailyItemViewController ()

@end

@implementation XdailyItemViewController
@synthesize xdailyitem_list=_xdailyitem_list;
@synthesize table;
@synthesize emptyinfo_label;
@synthesize channel_id=_channel_id;
@synthesize channel_title=_channel_title;
@synthesize channel=_channel;
EGORefreshTableHeaderView       *_refreshHeaderView;
BOOL                            _reloading;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllZipFinished) name:KAllTaskFinished object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:KUpdateWithMemory object:nil];
    }
    return self;
}
- (void)viewDidUnload
{
    [_xdailyitem_list release];
    [table release];
    [emptyinfo_label release];
    [_channel_id release];
    [_channel_title release];
    _refreshHeaderView=nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=self.channel_title;
//    UIView* booktopView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 832,640)];
//    booktopView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bigtablebg.png"]];
//    [self.view addSubview:booktopView];
//    [booktopView release];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    [table setSeparatorColor:[UIColor clearColor]];
    table.delegate =  self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self scrollViewDidScroll:self.table];
    
    
    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, 40,40)];
    UIImage *favor_image=[UIImage imageNamed:@"clip.png"];
    [favorBtn setImage:favor_image forState:UIControlStateNormal];
    [self.view addSubview:favorBtn];
    [favorBtn release];
    //   if (_refreshHeaderView == nil) {
    
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
    view.delegate = self;
    [self.table addSubview:view];
    _refreshHeaderView = view;
    [view release];
    _reloading=NO;
    //	}
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
    
    [self getItemsFormDBWithChannelID:self.channel_id];
    
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
    lab.text = self.channel_title;
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    
    
    
    UIButton* historyBut = [[UIButton alloc] initWithFrame:CGRectMake(270, 0, 43,43)];
    [historyBut setImage:[UIImage imageNamed:@"History.png"]  forState:UIControlStateNormal];
    [historyBut  addTarget:self action:@selector(historyAction) forControlEvents:UIControlEventTouchUpInside];
    
    [bimgv addSubview:historyBut];
    [historyBut release];
    [self.view addSubview:bimgv];
    [bimgv release];
    
    
    
    
    self.xdailyitem_list=[AppDelegate.db GetNewsByChannelID:self.channel_id];
    [self setExtraCellHidden:self.table];
    [self makeEmptyInfo];
    if([self.xdailyitem_list count]>0){
        [self hideEmptyInfo];
    }else{
        [self showEmptyInfo];
    }
}



-(void)historyAction{
    
    XdailyItemOlderViewController *aController = [[XdailyItemOlderViewController alloc] init];
    NSString*  url = [NSString stringWithFormat:KGetOlderNews,self.channel_id,[UIDevice customUdid]];
    
    aController.url=url;
    aController.type=@"http";
    aController.channel_title=self.channel_title;
    aController.channel_id=self.channel_id;
    aController.channel=self.channel;
    NSLog(@"channel_title_histroyAc__%@",self.channel_title);
    [self.navigationController pushViewController:aController animated:YES];
    [aController release];
    
}
-(void)backAction:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory object: self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)update{
    self.xdailyitem_list = [AppDelegate.db GetNewsByChannelID:self.channel_id];
    if([self.xdailyitem_list count]>0){
        [self hideEmptyInfo];
    }else{
        [self showEmptyInfo];
    }
    [self.table reloadData];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
-(void)appendTableWith:(XDailyItem *)data{
    [self.xdailyitem_list addObject:data];
    NSMutableArray *insertIndexPaths=[NSMutableArray arrayWithCapacity:10];
    NSIndexPath *newPath=[NSIndexPath indexPathForRow:[self.xdailyitem_list indexOfObject:data] inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.table insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XdailyItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if  (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSArray *views = [cell subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    UIView *btmLine=[[UIView alloc] initWithFrame:CGRectMake(5, 43, 290, 1)];
    btmLine.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"list_diver.png"]];
    [cell addSubview:btmLine];
    [btmLine release];
    
    UIImageView *cellbackground_image=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cellbackground.png"]];
    cell.backgroundView = cellbackground_image;
    [cellbackground_image release];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redarrow.png"]];
    image.frame = CGRectMake(300, 15, 11, 12);
    [cell addSubview:image];
    [image release];
    
    //    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redarrow.png"]];
    //    image.frame = CGRectMake(300, 15, 11, 12);
    //    [cell addSubview:image];
    //    [image release];
    
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
            labtext.font = [UIFont fontWithName:@"system" size:17];
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
            labtext.font = [UIFont fontWithName:@"system" size:17];
            labtext.textColor=[UIColor grayColor];
            [cell addSubview:labtext];
            [labtext release];
        }
    }
    return cell;
}
-(void)getItemsFormDBWithChannelID:(NSString *)channelID{
    self.xdailyitem_list = [AppDelegate.db GetNewsByChannelID:channelID];
    NSLog(@"%@",self.xdailyitem_list);
    [self.table reloadData];
    if([self.xdailyitem_list count]>0){
        [self hideEmptyInfo];
    }else{
        [self showEmptyInfo];
    }
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"generate = %@",self.channel.generate);
    if(self.channel.generate.intValue==1){
        ExpressPlusViewController *aController = [[ExpressPlusViewController alloc] init];
        XDailyItem * daily = [self.xdailyitem_list objectAtIndex:[self.table indexPathForSelectedRow].row];
        aController.siblings=self.xdailyitem_list;
        aController.index=indexPath.row;
        aController.type=@"file";
        aController.baseURL=@"";
        aController.channel_title=self.channel_title;  
        daily.isRead  = YES;
        [AppDelegate.db ModifyDailyNews:daily];
        [AppDelegate.db SaveDb];
        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory
                                                            object: self];
        
        [self.navigationController pushViewController:aController animated:YES];
        [aController release];
    }else{
        NewsListPlusViewController *aController = [[NewsListPlusViewController alloc] init];
        XDailyItem * daily = [self.xdailyitem_list objectAtIndex:[self.table indexPathForSelectedRow].row];
        aController.siblings=self.xdailyitem_list;
        aController.index=indexPath.row;
        aController.type=@"file";
        aController.baseURL=@"";
        aController.channel_title=self.channel_title;
        aController.item_title=self.channel_title;
        daily.isRead  = YES;
        [AppDelegate.db ModifyDailyNews:daily];
        [AppDelegate.db SaveDb];
        [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory object: self];
        [self.navigationController pushViewController:aController animated:YES];
        [aController release];
    }
}


-(void)GetXdailysFromWebToDb: (NSString *)channel_id
{
    [NewsDownloadTask downloadXdailyOfChannelId:channel_id topN:@"5"];
}

-(void)AllZipFinished{
    
    [self doneLoadingTableViewData];
}
- (void)fetchUpdate
{
    [self GetXdailysFromWebToDb:self.channel_id];
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    //[self fetchUpdate];
    [self performSelectorInBackground:@selector(fetchUpdate) withObject:nil];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
	
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

-(void)setExtraCellHidden:(UITableView *)tableview{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableview setTableFooterView:view];
    [view release];
}

-(void)showEmptyInfo{
    self.emptyinfo_label.hidden=NO;
}
-(void)makeEmptyInfo{
    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 100)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = @"无内容，可下拉更新";
    labtext.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    labtext.textAlignment=UITextAlignmentCenter;
    labtext.textColor=[UIColor grayColor];
    labtext.backgroundColor = [UIColor clearColor];
    self.emptyinfo_label=labtext;
    self.emptyinfo_label.hidden=YES;
    [self.view addSubview:labtext];
    [labtext release];
}
-(void)hideEmptyInfo{
    self.emptyinfo_label.hidden=YES;
}
@end
