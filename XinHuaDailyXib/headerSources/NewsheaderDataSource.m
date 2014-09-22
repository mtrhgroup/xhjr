//
//  NewsheaderDataSource.m
//  sxtv3
//
//  Created by apple on 13-3-25.
//  Copyright (c) 2013年 xhnet. All rights reserved.
//

#import "NewsheaderDataSource.h"
#import "XDailyItem.h"
#import "NewsManager.h"
#import "NewsContentSource.h"
#import "NSThread+detachNewThreadSelectorWithObjs.h"
NSString *cellReuseIdentifier =@"cellReuseIdentifier";
@implementation NewsheaderDataSource{
    NSArray *_items;
    BOOL _reloading;
    NewsManager *_manager;
}
@synthesize refreshheaderview=_refreshheaderview;
@synthesize tableview=_tableview;
@synthesize channel=_channel;
- (id)init
{
    self = [super init];
    if (self) {
        _manager=[[NewsManager alloc]init];
        _manager.delegate=self;
    }
    return self;
}
-(void)setItems:(NSArray *)items{
    _items=items;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

-(XDailyItem *)newsForIndexPath:(NSIndexPath *)indexPath{
    return [_items objectAtIndex:[indexPath row]];
}

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
    XDailyItem *item=[self newsForIndexPath:indexPath];
    if(item.thumbnail!=nil){
        PictureNews *pic_item=[PictureNewsBuilder picturenewsFromXDailyItem:item];
        pic_item.picture_view.frame=CGRectMake(5, 5, 60, 60);
        pic_item.picture_view.layer.cornerRadius = 5;
        pic_item.picture_view.layer.masksToBounds = YES;
        [[cell contentView] addSubview:pic_item.picture_view];
        UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 220, 30)];
        if(item.summary==nil){
            labtext.frame=CGRectMake(75,0,220,70);
        }else{
            labtext.frame=CGRectMake(75,0,220,30);
        }
        labtext.backgroundColor = [UIColor clearColor];
        labtext.text = item.title;
        labtext.font = [UIFont fontWithName:@"Arial" size:15];
        labtext.numberOfLines=2;
        
        [[cell contentView] addSubview:labtext];
        if(item.isRead){
            labtext.textColor=[UIColor grayColor];
            
        }
        UILabel* summarytext = [[UILabel alloc] initWithFrame:CGRectMake(75, 25, 220, 40)];
        summarytext.backgroundColor = [UIColor clearColor];
        summarytext.text = item.summary;
        NSLog(@"summary at cell%@",item.summary);
        summarytext.font = [UIFont fontWithName:@"Arial" size:10];
        summarytext.numberOfLines=2;
        summarytext.textColor=[UIColor grayColor];
        [[cell contentView] addSubview:summarytext];
        if(item.isRead){
            labtext.textColor=[UIColor grayColor];
        }
    }else{
        UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 285, 40)];
        labtext.frame=CGRectMake(10,0,285,30);
        labtext.backgroundColor = [UIColor clearColor];
        labtext.text = item.title;
        labtext.font = [UIFont fontWithName:@"Arial" size:15];
        labtext.numberOfLines=2;
        
        [[cell contentView] addSubview:labtext];
        if(item.isRead){
            labtext.textColor=[UIColor grayColor];
            
        }
        UILabel* summarytext = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 285, 40)];
        summarytext.backgroundColor = [UIColor clearColor];
        if(item.summary==nil){
            labtext.frame=CGRectMake(10,0,285,50);
            summarytext.frame=CGRectMake(10,45,285,30);
            summarytext.text = item.dateString;
        }else{
            summarytext.text = item.summary;
        }
        
        NSLog(@"summary at cell%@",item.summary);
        summarytext.font = [UIFont fontWithName:@"Arial" size:10];
        summarytext.numberOfLines=2;
        summarytext.textColor=[UIColor grayColor];
        [[cell contentView] addSubview:summarytext];
        if(item.isRead){
            labtext.textColor=[UIColor grayColor];
        }
    }
#ifdef LNZW
    UIImageView *arrow=[[UIImageView alloc] initWithImage:_channel.imgArrow];
    cell.accessoryView=arrow;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
#endif
    return cell;
}
-(BOOL)isPeriodiaclItem:(NewsChannel *)channel{
    XDailyItem *item=[_items objectAtIndex:0];
    NSLog(@"%@",[[item.localPath lastPathComponent] substringToIndex:5]);
    if([[[item.localPath lastPathComponent] substringToIndex:5]isEqualToString:@"index"]){
        return YES;
    }else{
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsContentSource *contentSource=[[NewsContentSource alloc]init];
    contentSource.title=_channel.title;
    contentSource.siblings=_items;
    contentSource.index=indexPath.row;
    NSLog(@"%@ %d",_channel.title,_channel.generate.intValue);
    if([self isPeriodiaclItem:_channel]){
        NSNotification *note=[NSNotification notificationWithName:PeriodicalNewsHeaderSelectionNotification object:contentSource];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }else{
        NSNotification *note=[NSNotification notificationWithName:ExpressNewsHeaderSelectionNotification object:contentSource];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==[_items count]-1){
        if([_items count]>6){
          [self createTableFooter];
          [self loadDataBegin];
        }else{
            [self removeTableFooter];
        }
    }
}
-(void)reloadData{
    [self reloadDataFromCoreData];
    if([_channel isOld]){
        [self simulatePullHeaderView];
    }
}

-(void)simulatePullHeaderView{
    //it shouled be a number less than -65,here is -70.
    _tableview.contentOffset=CGPointMake(0, -70);
    [_refreshheaderview egoRefreshScrollViewDidEndDragging:_tableview];
}

-(void)reloadDataFromCoreData{
    [_manager fetchNewsHeadersFromCoreDataInThreadWithChannel:_channel];
}


- (void)didReceiveNewsHeaders:(NSArray *)items{
    [self performSelectorOnMainThread:@selector(updateUIWithNews:) withObject:items waitUntilDone:YES];
}

-(void)updateUIWithNews:(NSArray *)items{
    [self setItems:items];
    [_tableview reloadData];
    [self doneLoadingTableViewData];
}

-(void)getMoreXdailysFromWebToDb:(NSString *)channel_id oldestXdailyId:(NSString *)oldestXdailyId xdailyCount:(NSString *)xdailyCount{
    NSLog(@"oldestXdailyId :%@",oldestXdailyId);
    [_manager fetchMoreNewsItemsWithChannel:channel_id oldestXdailyId:oldestXdailyId xdailyCount:xdailyCount];
}
-(void)didReceiveMoreNewsItems:(NSArray *)items{
    [self loadDataEnd];
    if([items count]>[_items count]){
        [self performSelectorOnMainThread:@selector(updateUIWithNews:) withObject:items waitUntilDone:YES];
    }else{
       self.tableview.tableFooterView=nil; 
    }    
    
}
-(void)fetchMore{
    @autoreleasepool {
        if([_items count]==0){
            [self loadDataEnd];
            return;
        }
        int oldestXdailyId=((XDailyItem *)[_items lastObject]).item_id.intValue;
        NSString * oldestId=[NSString stringWithFormat:@"%d",oldestXdailyId];
        NSString *xdailyCount=[NSString stringWithFormat:@"%d",[_items count]];
        [NSThread detachNewThreadSelector:@selector(getMoreXdailysFromWebToDb:oldestXdailyId:xdailyCount:) toTarget:self withObject:self.channel.channel_id and2Object:oldestId and3Object:xdailyCount];
    }
}
// 开始加载数据
- (void) loadDataBegin
{
    if (_reloading == NO)
    {
        //_reloading = YES;
        UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)];
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [tableFooterActivityIndicator startAnimating];
        [self.tableview.tableFooterView addSubview:tableFooterActivityIndicator];
        
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
}
-(void)removeTableFooter{
    self.tableview.tableFooterView=nil;
}
- (void) createTableFooter
{
    if([_items count]==0)return;
    self.tableview.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableview.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多数据"];
    [tableFooterView addSubview:loadMoreText];
    
    self.tableview.tableFooterView = tableFooterView;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [_manager synchronizationAndFetchNewsHeadersInThreadWithChannel:_channel];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshheaderview egoRefreshScrollViewDataSourceDidFinishedLoading:_tableview];
	
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshheaderview egoRefreshScrollViewDidScroll:scrollView];
//    if(!_reloading && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
//    {
//        NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
//        if([_items count]<[setdate intValue]&&[_items count]>0)
//            [self loadDataBegin];
//        else
//            self.tableview.tableFooterView=nil;
//    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshheaderview egoRefreshScrollViewDidEndDragging:scrollView];
	
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
NSString *PeriodicalNewsHeaderSelectionNotification=@"PeriodicalNewsHeaderSelectionNotification";
NSString *ExpressNewsHeaderSelectionNotification=@"ExpressNewsHeaderSelectionNotification";
NSString *PictureNewsHeaderSelectionNotification=@"PictureNewsHeaderSelectionNotification";
@end
