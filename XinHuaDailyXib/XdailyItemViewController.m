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
BOOL _displayMode;
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
    _refreshHeaderView=nil;
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
    self.navigationItem.title=self.channel_title;
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0))];
    NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
    if(displayMode==nil||[displayMode isEqualToString:@"日间模式"]){        
        self.view.backgroundColor = [UIColor whiteColor];
        table.backgroundColor= [UIColor whiteColor];
    }else{
        self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        table.backgroundColor= [UIColor colorWithRed:30.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.0];
    }
    [table setSeparatorColor:[UIColor clearColor]];
    table.delegate =  self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self scrollViewDidScroll:self.table];
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 57.0)];
    UIButton* btnNextPage = [[UIButton alloc] initWithFrame:footerView.frame];
    btnNextPage.titleLabel.text = NSLocalizedString(@"next_page", null);
    [footerView addSubview:btnNextPage];
    table.tableFooterView=footerView;
    
    
    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, 40,40)];
    UIImage *favor_image=[UIImage imageNamed:@"clip.png"];
    [favorBtn setImage:favor_image forState:UIControlStateNormal];
    [self.view addSubview:favorBtn];
    //   if (_refreshHeaderView == nil) {
    
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
    view.delegate = self;
    [self.table addSubview:view];
    _refreshHeaderView = view;
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
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 40)];
    lab.text = self.channel_title;
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    [bimgv addSubview:lab]; 
    UIButton* historyBut = [[UIButton alloc] initWithFrame:CGRectMake(270, 0, 43,43)];
    [historyBut setImage:[UIImage imageNamed:@"History.png"]  forState:UIControlStateNormal];
    [historyBut  addTarget:self action:@selector(historyAction) forControlEvents:UIControlEventTouchUpInside];
    
    [bimgv addSubview:historyBut];
    [self.view addSubview:bimgv];   
    self.xdailyitem_list=[AppDelegate.db GetNewsByChannelID:self.channel_id];
    [self setExtraCellHidden:self.table];
    [self makeEmptyInfo];
    if([self.xdailyitem_list count]>0){
        [self hideEmptyInfo];
    }else{
        [self showEmptyInfo];
    }
    [self createTableFooter];
}



-(void)historyAction{
    
    XdailyItemOlderViewController *aController = [[XdailyItemOlderViewController alloc] init];
    NSString*  url = [NSString stringWithFormat:KGetOlderNews,self.channel_id,[UIDevice customUdid]];
    NSLog(@"%@",url);
    aController.url=url;
    aController.type=@"http";
    aController.channel_title=self.channel_title;
    aController.channel_id=self.channel_id;
    aController.channel=self.channel;
    NSLog(@"channel_title_histroyAc__%@",self.channel_title);
    [self.navigationController pushViewController:aController animated:YES]; 
}
-(void)backAction:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateWithMemory object: self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)update{
    [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:NO];
}
-(void)updateUI{
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *views = [cell subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    UIView *btmLine=[[UIView alloc] initWithFrame:CGRectMake(5, 43, 290, 1)];
    btmLine.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"list_diver.png"]];
    [cell addSubview:btmLine];
    UIImageView *cellbackground_image;
    NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
    if(displayMode==nil||[displayMode isEqualToString:@"日间模式"]){
        cellbackground_image=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cellbackground.png"]];
    }else{
        cellbackground_image=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cellbackground_dark.png"]];
    }
    cell.backgroundView = cellbackground_image;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redarrow.png"]];
    image.frame = CGRectMake(300, 15, 11, 12);
    [cell addSubview:image];
    if([self.xdailyitem_list count]>0){
        XDailyItem *itemAtIndex = [self.xdailyitem_list objectAtIndex:indexPath.row];
        if(!itemAtIndex.isRead){
            UIImageView* mv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 15, 15)];
            mv.image = [UIImage imageNamed:@"red.png"];
            [cell addSubview:mv];
            UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
            labtext.backgroundColor = [UIColor clearColor];
            labtext.text = itemAtIndex.title;
            labtext.font = [UIFont fontWithName:@"system" size:17];
            labtext.textColor=[UIColor blackColor];
            [cell addSubview:labtext];
        }else{
            UIImageView* mv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 15, 15)];
            mv.image = [UIImage imageNamed:@"unread_dot.png"];
            [cell addSubview:mv];
            
            UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
            labtext.backgroundColor = [UIColor clearColor];
            labtext.text = itemAtIndex.title;
            labtext.font = [UIFont fontWithName:@"system" size:17];
            labtext.textColor=[UIColor grayColor];
            [cell addSubview:labtext];
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
    XDailyItem * daily = [self.xdailyitem_list objectAtIndex:[self.table indexPathForSelectedRow].row];
    NSString* url=[daily.pageurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString* filename=[[url lastPathComponent] stringByDeletingPathExtension];
    NSLog(@"%@",[[url lastPathComponent] stringByDeletingPathExtension]);
    if(![filename isEqualToString:@"index"]){
        ExpressPlusViewController *aController = [[ExpressPlusViewController alloc] init];        
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
    }else{
        NewsListPlusViewController *aController = [[NewsListPlusViewController alloc] init];
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
    }
}

-(void)getMoreXdailysFromWebToDb:(NSString *)channel_id oldestXdailyId:(NSString *)oldestXdailyId xdailyCount:(NSString *)xdailyCount{
    NSLog(@"oldestXdailyId :%@",oldestXdailyId);
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NewsDownloadTask *task=[[NewsDownloadTask alloc] initWithDB:db];
    [task downloadMoreXdailyWithOldestXdailyId:oldestXdailyId channelId:channel_id xdailyCount:xdailyCount];
}
-(void)GetXdailysFromWebToDb: (NSString *)channel_id
{
    NSLog(@"channel id :%@",channel_id);
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NewsDownloadTask *task=[[NewsDownloadTask alloc] initWithDB:db];
    [task downloadXdailyOfChannelId:channel_id topN:@"10"];
}

-(void)AllZipFinished{
    [self loadDataEnd];
    
    [self doneLoadingTableViewData];
}
- (void)fetchUpdate
{
    @autoreleasepool {
        [NSThread detachNewThreadSelector:@selector(GetXdailysFromWebToDb:) toTarget:self withObject:self.channel_id];
    }
}
-(void)fetchMore{
    @autoreleasepool {
        if([self.xdailyitem_list count]==0)return;
        int oldestXdailyId=((XDailyItem *)[self.xdailyitem_list objectAtIndex:[self.xdailyitem_list count]-1]).item_id.intValue;
        NSString * oldestId=[NSString stringWithFormat:@"%d",oldestXdailyId];
        NSString *xdailyCount=@"10";
        [NSThread detachNewThreadSelector:@selector(getMoreXdailysFromWebToDb:oldestXdailyId:xdailyCount:) toTarget:self withObject:self.channel_id and2Object:oldestId and3Object:xdailyCount];
    }
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self fetchUpdate];
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
    if(!_reloading && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
        if([self.xdailyitem_list count]<[setdate intValue]&&[self.xdailyitem_list count]>0)
            [self loadDataBegin];
        else
            self.table.tableFooterView=nil;
    }
    
}
// 开始加载数据
- (void) loadDataBegin
{
    if (_reloading == NO)
    {
        _reloading = YES;
        UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)];
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [tableFooterActivityIndicator startAnimating];
        [self.table.tableFooterView addSubview:tableFooterActivityIndicator];
        
        [self loadDataing];
    }
}

// 加载数据中
- (void) loadDataing
{
    [self fetchMore];
}

- (void) loadDataEnd
{
    _reloading = NO;
    NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
    if([self.xdailyitem_list count]==[setdate intValue])
        self.table.tableFooterView=nil;
    else
        [self createTableFooter];
}
- (void) createTableFooter
{
    if([self.xdailyitem_list count]==0)return;
    self.table.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.table.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多数据"];
    [tableFooterView addSubview:loadMoreText];
    
    self.table.tableFooterView = tableFooterView;
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
@end
