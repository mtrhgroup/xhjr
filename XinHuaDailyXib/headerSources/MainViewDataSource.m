//
//  MainViewDataSource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-8-15.
//
//

#import "MainViewDataSource.h"
#import "NewsContentSource.h"
#import "NewsDownloadImgTask.h"
NSString *maincellReuseIdentifier =@"picturenews";
@implementation MainViewDataSource{
    NSArray *_channels;
    BOOL _reloading;
    NewsManager *_manager;
    UIScrollView *_scrollview;
    UIPageControl *_pagecontrol;
    UILabel *_picTitleLabel;
    NSArray *_pictures;
    NSTimer *_timer;
}
@synthesize refreshheaderview=_refreshheaderview;
@synthesize tableview=_tableview;

- (id)init
{
    self = [super init];
    if (self) {
        _manager=[[NewsManager alloc]init];
        _manager.delegate=self;
        _timer=[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(changePic) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)setChannels:(NSArray *)items{
    _channels=items;
}



-(NewsChannel *)channelForSection:(NSInteger)section{
    return [_channels objectAtIndex:section];
}
-(XDailyItem *)newsForIndexPath:(NSIndexPath *)indexPath{
    return [_channels objectAtIndex:[indexPath row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:maincellReuseIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:maincellReuseIdentifier];
    }
    NSArray *views = [[cell contentView] subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    } 
    if(indexPath.section==0){
        [[cell contentView] addSubview:[self createPictureView]];
        [self loadPictures:[self channelForSection:0].items];
        cell.accessoryView=nil;
    }else{
        if([[self channelForSection:indexPath.section].items count]==0){
            return cell;
        }
        XDailyItem *item=[[self channelForSection:indexPath.section].items objectAtIndex:indexPath.row];
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
        UIImageView *arrow=[[UIImageView alloc] initWithImage:[self channelForSection:indexPath.section].imgArrow];
        cell.accessoryView=arrow;
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
#endif
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (UIImage *) drawView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
-(UIView *)createPictureView{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 180)];
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    _scrollview.contentSize = CGSizeMake(320 * 1, 180);
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = YES;
    _scrollview.delegate =  self;
    _scrollview.backgroundColor = [UIColor whiteColor];
    _scrollview.pagingEnabled = YES;
    UIImage *img=[UIImage imageNamed:@"default_image.png"];
    img=[img scaleToSize:CGSizeMake(320, 180)];
    UIButton *btn=[[UIButton alloc] init];
    btn.backgroundColor=[UIColor colorWithPatternImage:img];
    btn.tag=0;
    CGRect frame = _scrollview.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
    btn.frame = frame;
    [_scrollview addSubview:btn];
    _scrollview.bounces=NO;
    [view addSubview:_scrollview];
    //放小横图
    UIImageView* imv = [[UIImageView alloc] initWithFrame:CGRectMake(0,160 , 320 , 20)];
    imv.image = [UIImage imageNamed:@"heise.png"];
    _picTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 23)];
    _picTitleLabel.backgroundColor = [UIColor clearColor];
    _picTitleLabel.text = @"";
    _picTitleLabel.textColor = [UIColor whiteColor];
    _picTitleLabel.font = [UIFont fontWithName:@"Arial" size:15];
    [imv addSubview:_picTitleLabel];
    [view addSubview:imv];
    _pagecontrol =[[UIPageControl alloc] initWithFrame:CGRectMake(220, -20, 86, 16)];
    _pagecontrol.numberOfPages = 1;
    _pagecontrol.currentPage = 0;
    [imv addSubview:_pagecontrol];
    return view;
}
-(void)loadPictures:(NSArray *)items{
    _pictures=[self xdailysToPictures:items];
    if([_pictures count]>0){
        _scrollview.contentSize=CGSizeMake(_scrollview.frame.size.width * [_pictures count], _scrollview.frame.size.height);
        for(int i=0;i<[_pictures count];i++){
            PictureNews *pic_news=[_pictures objectAtIndex:i];
            NSLog(@"%@",pic_news.picture_url);
            NSLog(@"%@",pic_news.zipurl);
            UIImage *img;
            if(pic_news.thumbnail==nil){
              img=[[UIImage alloc] initWithContentsOfFile:pic_news.picture_url];
            }else{
               img=[[UIImage alloc] initWithContentsOfFile:pic_news.picture_view.imageUrl];
            }
            img=[img scaleToSize:CGSizeMake(320, 180)];
            UIButton *btn=[[UIButton alloc] init];
            btn.backgroundColor=[UIColor colorWithPatternImage:img];
            btn.tag=i;
            [btn addTarget:self action:@selector(showArticle:) forControlEvents:UIControlEventTouchUpInside];
            CGRect frame = _scrollview.frame;
            frame.origin.x = frame.size.width * i;
            frame.origin.y = 0;
            btn.frame = frame;
            [_scrollview addSubview:btn];
        }
        _pagecontrol.numberOfPages=[_pictures count];
        _picTitleLabel.text=((PictureNews *)[_pictures objectAtIndex:0]).picture_title;
    }
}

-(NSArray *)xdailysToPictures:(NSArray *)items{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for(XDailyItem *item in items){
        [arr addObject:[PictureNewsBuilder picturenewsFromXDailyItem:item]];
    }
    return arr;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UIView *subView=[[UIView alloc]initWithFrame:CGRectMake(5, 5, 310, 20)];
    [headerView addSubview:subView];
    [subView setBackgroundColor:[self channelForSection:section].color];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(3, 1, 300, 18)];
    titleLabel.text=[self channelForSection:section].title;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
    [subView addSubview:titleLabel];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_channels count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog(@"%@",[self channelForSection:section].title);
    return [self channelForSection:section].title;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }else{
        return [[self channelForSection:section].items count];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section]==0){
        return 180;
    }else{
        return 70;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else{
        if([[self channelForSection:section].items count]==0){
            return 0;
        }else{
            return 30;
        }
        
    }
}
-(BOOL)isPeriodiaclItem:(NewsChannel *)channel{
    XDailyItem *item=[channel.items objectAtIndex:0];
    NSLog(@"%@",[[item.localPath lastPathComponent] substringToIndex:5]);
    if([[[item.localPath lastPathComponent] substringToIndex:5]isEqualToString:@"index"]){
        return YES;
    }else{
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsContentSource *contentSource=[[NewsContentSource alloc]init];
    contentSource.title=[self channelForSection:indexPath.section].title;
    contentSource.siblings=[self channelForSection:indexPath.section].items;
    contentSource.index=indexPath.row;
    if([self isPeriodiaclItem:[self channelForSection:indexPath.section]]){
        NSNotification *note=[NSNotification notificationWithName:PeriodicalNewsHeaderSelectionNotification object:contentSource];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }else{
        NSNotification *note=[NSNotification notificationWithName:ExpressNewsHeaderSelectionNotification object:contentSource];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}
-(void)showArticle:(id)sender{    
    NewsContentSource *contentSource=[[NewsContentSource alloc]init];
    contentSource.title=@"图片新闻";
    contentSource.siblings=_pictures;
    contentSource.index=((UIButton *)sender).tag;
    NSNotification *note=[NSNotification notificationWithName:ExpressNewsHeaderSelectionNotification object:contentSource];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

-(void)simulatePullHeaderView{
    //it shouled be a number less than -65,here is -70.
    _tableview.contentOffset=CGPointMake(0, -70);
    [_refreshheaderview egoRefreshScrollViewDidEndDragging:_tableview];
}

-(void)reloadDataFromCoreData{
    [_manager fetchDataForMainView:super.channel];
}


- (void)didReceiveNewsHeaders:(NSArray *)items{
    [self performSelectorOnMainThread:@selector(updateUIWithNews:) withObject:items waitUntilDone:YES];
}

-(void)updateUIWithNews:(NSArray *)items{
    [self setChannels:items];
    [_tableview reloadData];
    //[self doneLoadingTableViewData];
}

-(void)reloadData{
    if([super.channel isOld]){
        [self simulatePullHeaderView];
    }else{
        [self reloadDataFromCoreData];
    }
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
    [[NewsDownloadImgTask sharedInstance] execute];
    [_manager synchronizationAndFetchDataForMainViewInThead:self.channel];
    [_manager executeModifyActionsInThread];
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
	if(scrollView==_tableview){
        [_refreshheaderview egoRefreshScrollViewDidScroll:scrollView];
    }else{
        CGFloat pageWidth = _scrollview.frame.size.width;
        int page = floor((_scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _pagecontrol.currentPage = page;
        PictureNews *pic_news=[_pictures objectAtIndex:page];
        _picTitleLabel.text=pic_news.picture_title;
        pic_no=page;
    }
}
static int pic_no=0;
-(void)changePic{
    if(pic_no<[_pictures count]){
        pic_no++;
    }else{
        pic_no=0;
    }
    [self turnPageTo:pic_no];
}
-(void)turnPageTo:(int)index{
    if(index>=0&&index<[_pictures count]){
        _pagecontrol.currentPage = index;
        [_scrollview scrollRectToVisible:CGRectMake(320*index,0,320,180) animated:NO];
        PictureNews *pic_news=[_pictures objectAtIndex:index];
        _picTitleLabel.text=pic_news.picture_title;
    }
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
@end
