//
//  XinHuaViewController.m
//  XinHuaDailyXib
//
//  Created by zhang jun on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "XinHuaViewController.h"
#import "NewsDbOperator.h"
#import "XdailyItemViewController.h"
#import "SettingViewController.h"
#import "SubscribeViewController.h"
#import "XDailyItem.h"
#import "NewsDefine.h"
#import "ASIHTTPRequest.h"
#import "NSIks.h"
#import "NewsChannel.h"
#import "XinHuaAppDelegate.h"
#import "RegisterViewController.h"
#import "NewsXmlParser.h"
#import "NewsInBoxViewController.h"
#import "PictureNews.h"
#import "FavorBoxViewController.h"
#import "NewsListPlusViewController.h"
#import "ExpressPlusViewController.h"
#import "PicturePlusViewController.h"
#import "ContactUsViewController.h"
#import "GalleryViewController.h"
#import "GallerySource.h"
#import "CustomBadge.h"
#import "Toast+UIView.h"
#import "NewsDownloadTask.h"
#import "AppInfo.h"
/*
 * notification : KShowToast           "显示后台任务的执行反馈"      userInfo:data  (NSString *) "执行反馈的文本信息"
 *                KUpdateWithMemory    “用后台数据更新频道列表”
 *                KUpdatePicture       “用后台数据更新图片专栏”
 *                KAllTaskFinished     “所有更新任务执行完成”   
 *
 */
@implementation XinHuaViewController

BOOL pageControlUsed;
BOOL                            _reloading;
@synthesize pagecontrol;
@synthesize scrollview;
@synthesize table;
@synthesize channel_list;
@synthesize channel_read_list;
@synthesize tools_view;


@synthesize picturenews_array=_picturenews_array;
@synthesize pic_index;
@synthesize picTitleLabel;
@synthesize expressMarquee;
@synthesize toVipBtn;
@synthesize refreshHeaderView=_refreshHeaderView;
@synthesize expressPlusViewController=_expressPlusViewController;
@synthesize newsListPlusViewController=_newsListPlusViewController;
@synthesize xdailyItemViewController=_xdailyItemViewController;
int timer_count;
CustomBadge *unread_inbox;
NSTimer *timer;
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

#pragma mark - View lifecycle
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetdatafromWebToDb) name:KEnterForeground object:AppDelegate];       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithMemory) name:KUpdateWithMemory object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pictureReadyHandler) name:KUpdatePicture object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTaskInfo) name:KShowToast object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleDisplayMode) name:KDisplayMode object:nil];
    }
    return self;
}

-(void)toggleDisplayMode{
    NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
    if(displayMode==nil||[displayMode isEqualToString:@"日间模式"]){
        self.view.backgroundColor = [UIColor whiteColor];
        table.backgroundColor= [UIColor whiteColor];
    }else{
        self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        table.backgroundColor= [UIColor colorWithRed:30.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.0];
    }
}

-(void)enterForegroundHandler{
    NSLog(@"enterForegroundHandler");
    [self GetdatafromWebToDb];
}

-(void)GetdatafromWebToDb{
    NSLog(@"GetdatafromWebToDb");
#if InHouseDistribution
    if(![[NewsRegisterTask sharedInstance] isRegistered])return;
#endif
    @autoreleasepool {
        [NSThread detachNewThreadSelector:@selector(updateMainView) toTarget:self withObject:nil];
    }
}
-(void)updateMainView{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NewsDownloadTask *task=[[NewsDownloadTask alloc] initWithDB:db];
    [task GetdatafromWebToDb];
    NSLog(@"download main data OK");
}
-(void)updateWithMemory{
    [self performSelector:@selector(update) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    NSLog(@"updateWithMemory");
}
-(void)showTaskInfo{
    NSLog(@"showTaskInfo");
}
-(void)allTaskFinishedHandler{
    NSLog(@"allTaskFinishedHandler");
}
-(void)pictureReadyHandler{
    NSLog(@"pictureReadyHandler");
    [self performSelector:@selector(loadPictures) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIApplication sharedApplication]   registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = YES;
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"version_info"];
    AppInfo *version_info=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(version_info==nil||version_info.groupTitle==nil){
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        lab.text = @"新华时讯通";
        lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:21];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
        [bimgv addSubview:lab];
    }else{
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        lab.text = version_info.groupTitle;
        lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:21];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
        [bimgv addSubview:lab];
    }
//#if defined(SXT)   
//    UIImageView* zhong = [[UIImageView alloc] initWithFrame:CGRectMake(87, 5, 123, 28)];
//    zhong.image = [UIImage imageNamed:@"title.png"];
//    [bimgv addSubview:zhong];
//    [zhong release];
//#endif
//
//#if defined(GXZW)
//    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    lab.text = @"新华政务在线";
//    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:21];
//    lab.textAlignment = UITextAlignmentCenter;
//    lab.backgroundColor = [UIColor clearColor];
//    lab.textColor = [UIColor whiteColor];
//    [bimgv addSubview:lab];
//    [lab release];
//#endif
//#if defined(HNZW)
//    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    lab.text = @"新华时讯通舆情资讯";
//    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:21];
//    lab.textAlignment = UITextAlignmentCenter;
//    lab.backgroundColor = [UIColor clearColor];
//    lab.textColor = [UIColor whiteColor];
//    [bimgv addSubview:lab];
//    [lab release];
//#endif
//    
//#if defined(LNZW)
//    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    lab.text = @"辽宁舆情参考";
//    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:21];
//    lab.textAlignment = UITextAlignmentCenter;
//    lab.backgroundColor = [UIColor clearColor];
//    lab.textColor = [UIColor whiteColor];
//    [bimgv addSubview:lab];
//    [lab release];
//
//#endif
    [self.view addSubview:bimgv];
    
   // self.view.backgroundColor = [UIColor whiteColor];
    self.channel_list  = nil;
    //添加scrollview
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 180)];
    scrollview.contentSize = CGSizeMake(320 * 1, 180);
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = YES;
    scrollview.delegate =  self;
    scrollview.backgroundColor = [UIColor whiteColor];
    scrollview.pagingEnabled = YES;
    UIImage *img=[UIImage imageNamed:@"ad.png"];
    img=[img scaleToSize:CGSizeMake(320, 180)];
    UIButton *btn=[[UIButton alloc] init];
    btn.backgroundColor=[UIColor colorWithPatternImage:img];
    btn.tag=0;
    CGRect frame = self.scrollview.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
    btn.frame = frame;
    [scrollview addSubview:btn];
    [self.view addSubview:scrollview];   
    //放小横图
    UIImageView* imv = [[UIImageView alloc] initWithFrame:CGRectMake(0,160+44 , 320 , 23)];
    imv.image = [UIImage imageNamed:@"heise.png"];  
    picTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 23)];
    picTitleLabel.backgroundColor = [UIColor clearColor];
    picTitleLabel.text = @"";
    picTitleLabel.textColor = [UIColor whiteColor];
    picTitleLabel.font = [UIFont fontWithName:@"Arial" size:15];
    [imv addSubview:picTitleLabel];
    [self.view addSubview:imv];
    pagecontrol =[[UIPageControl alloc] initWithFrame:CGRectMake(220, -20, 86, 16)];
    pagecontrol.numberOfPages = 1;
    pagecontrol.currentPage = 0;
    [imv addSubview:pagecontrol];
    //加入展示
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 180+44, 320, 193+(iPhone5?88:0)) style:UITableViewStylePlain];
    [table setSeparatorColor:[UIColor clearColor]];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    unread_inbox = [CustomBadge customBadgeWithString:@"0"
                                      withStringColor:[UIColor whiteColor]
                                       withInsetColor:[UIColor redColor]
                                       withBadgeFrame:YES
                                  withBadgeFrameColor:[UIColor whiteColor]
                                            withScale:0.7
                                          withShining:YES];
    UIButton* mail = [[UIButton alloc] initWithFrame:CGRectMake(270, 8, 43,29)];
    [unread_inbox setFrame:CGRectMake(mail.frame.size.width-15, -5, unread_inbox.frame.size.width, unread_inbox.frame.size.height)];
    unread_inbox.hidden=YES;
    
    UIImage *image=[UIImage imageNamed:@"mail.png"];
    [mail setImage:image forState:UIControlStateNormal];
    [mail addSubview:unread_inbox];
    [mail  addTarget:self action:@selector(showInboxScene) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *badgeButton=[[UIButton alloc]  initWithFrame:CGRectMake(260, 0, 53,37)];
    [badgeButton  addTarget:self action:@selector(showInboxScene) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:badgeButton];    
    [self.view addSubview:mail];
    
//    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 176+44, 25,35)]; 
//    UIImage *favor_image=[UIImage imageNamed:@"flag_favor_big.png"];
//    [favorBtn setImage:favor_image forState:UIControlStateNormal];
//    [favorBtn  addTarget:self action:@selector(showFavorScene) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:favorBtn];
//    [favorBtn release];
    
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
    view.delegate = self;
    [self.table addSubview:view];
    _refreshHeaderView = view;
    _reloading=NO;
    
    UIView* uv = [[UIView alloc] initWithFrame:CGRectMake(0, 373+44+(iPhone5?88:0), 320, 44)];
    uv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottombg.png"]];
    UIButton* MenuBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 35,35)];
    UIImage *menu_image=[UIImage imageNamed:@"ext_nav_columns.png"];
    [MenuBtn setImage:menu_image forState:UIControlStateNormal];
    MenuBtn.showsTouchWhenHighlighted=YES;
    [MenuBtn  addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:MenuBtn];
    [self.view addSubview:uv];   
    [self makeToolPannel];
    [self update];
    UIView *horsebar=[[UIView alloc]initWithFrame:CGRectMake(42, 426+(iPhone5?88:0), 270, 27)];
    horsebar.clipsToBounds=YES;
    [self.view addSubview:horsebar];   
    self.expressMarquee=[[ExpressMarquee alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [self.expressMarquee setBackgroundColor:[UIColor clearColor]];
    [self.expressMarquee setTag:999];
    [self.expressMarquee setShowLap:1];
    timer_count=-1;
    NSDictionary *dicLabel=[NSDictionary dictionaryWithObjectsAndKeys:@"", @"TEXT_CONTENT",[UIColor whiteColor],@"TEXT_COLOR",[UIFont fontWithName:@"Arial" size:18],@"TEXT_FONT",nil];
    [self.expressMarquee setShowText:dicLabel];
    [self.expressMarquee calculateShowFrame];
    UIView *marqueeView=[self.view viewWithTag:999];
    if(marqueeView){
        [marqueeView removeFromSuperview];
    }
    [horsebar addSubview:self.expressMarquee];
    
    UIButton *btnMarqueeClick=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnMarqueeClick setFrame:CGRectMake(0, 0, 300, 27)];
    [btnMarqueeClick addTarget:self action:@selector(clickMarquee) forControlEvents:UIControlEventTouchDown];
    [horsebar addSubview:btnMarqueeClick];
    [self GetdatafromWebToDb];
    [self loadPictures];
    //timer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(changeText) userInfo:nil repeats:YES];
    [self toggleDisplayMode];
}

-(void)changeText{
    NSMutableArray *items=[AppDelegate.db GetKuaiXun];
    NSLog(@"$$$%d",[items count]);
    if([items count]>0){
        timer_count++;
        if(timer_count>=[items count])timer_count=0;
        XDailyItem *item=[items objectAtIndex:timer_count];
        NSDictionary *dicLabel=[NSDictionary dictionaryWithObjectsAndKeys:item.title, @"TEXT_CONTENT",[UIColor whiteColor],@"TEXT_COLOR",[UIFont fontWithName:@"Arial" size:18],@"TEXT_FONT",nil];
        [self.expressMarquee setShowText:dicLabel];
        [self.expressMarquee calculateShowFrame];
    }else{
        NSDictionary *dicLabel=[NSDictionary dictionaryWithObjectsAndKeys:@"", @"TEXT_CONTENT",[UIColor whiteColor],@"TEXT_COLOR",[UIFont fontWithName:@"Arial" size:18],@"TEXT_FONT",nil];
        [self.expressMarquee setShowText:dicLabel];
        [self.expressMarquee calculateShowFrame];
    }
}
-(void)clickMarquee{
    [self hideToolPannel];
    ExpressPlusViewController *aController = [[ExpressPlusViewController alloc] init] ;
    NSMutableArray *items=[AppDelegate.db GetKuaiXun];
    if(timer_count<0||timer_count>=[items count])return;
    XDailyItem *item=[items objectAtIndex:timer_count];
    aController.baseURL=@"";
    aController.siblings=items;
    aController.index=timer_count;
    aController.type=@"file";
    aController.channel_title=@"专题快讯";
    item.isRead  = YES;
    [AppDelegate.db ModifyDailyNews:item];
    [AppDelegate.db SaveDb];
    [self.navigationController pushViewController:aController animated:YES];
}
-(void)menu{
    if([self isRegistered]){
        self.toVipBtn.enabled=false;
    }else{
        self.toVipBtn.enabled=true;
    }
    if(self.tools_view.hidden==true){
        self.tools_view.hidden=false;
    }else{
        self.tools_view.hidden=true;
    }
}

-(void)showToolPannel{
    if([self isRegistered]){
        self.toVipBtn.enabled=false;
    }else{
        self.toVipBtn.enabled=true;
    }
    self.tools_view.hidden=false;
}

-(BOOL)isRegistered{
    NSString* authcode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode];
    NSLog(@"%@",authcode);
    if(authcode==nil)
        return NO;
    else return YES;
}
-(void)hideToolPannel{
    self.tools_view.hidden=true;
}

-(void)showFavorScene{
     [self hideToolPannel];
    FavorBoxViewController* fbv = [[FavorBoxViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:fbv];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)showAboutScene{
    [self hideToolPannel];
    XDAboutViewController* about = [[XDAboutViewController alloc] init];
    about.mode=0;
    [self presentViewController:about animated:YES completion:nil];
}
-(void)showSubscribeScene{
    [self hideToolPannel];   
    SubscribeViewController* sub = [[SubscribeViewController alloc] init];
    UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:sub];
    [self presentViewController:unc animated:YES completion:nil];
}
-(void)showVipScene{
    [self hideToolPannel];
    RegisterViewController* rvc = [[RegisterViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:rvc];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)showGalleryScene{
    [self hideToolPannel];    
    GallerySource* gs=[[GallerySource alloc]initWithPictureNewsArray:self.picturenews_array];
    GalleryViewController* gvc=[[GalleryViewController alloc]initWithPhotoSource:gs];
    UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:gvc];
    [self presentViewController:unc animated:YES completion:nil];
}
-(void)showInboxScene{
    [self hideToolPannel];
    NewsInBoxViewController* nbx = [[NewsInBoxViewController alloc] init];
    UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:nbx];
    [self presentViewController:unc animated:YES completion:nil];
}

-(void)showFeedBackScene{
    [self hideToolPannel];
    ContactUsViewController* nbx = [[ContactUsViewController alloc] init];
    UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:nbx];
    nbx.mode=0;
    [self presentViewController:unc animated:YES completion:nil];
}


-(void)showSettingScene{    
    [self hideToolPannel];    
    SettingViewController* svc = [[SettingViewController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:svc];
    [self presentViewController:nav animated:YES completion:nil];
}


-(void)makeToolPannel{
    UIView * toolsview=[[UIView alloc] initWithFrame:CGRectMake(3, 300+44+(iPhone5?88:0), 314, 74)];
    toolsview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"toolsbg.png"]];
    toolsview.hidden=true;
    self.tools_view=toolsview;
    [self.view addSubview:toolsview];
#if InHouseDistribution
    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 15, 60,44)];
#else
    UIButton* favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 15, 60,44)];
#endif
    UIImage *image=[UIImage imageNamed:@"favor_white.png"];
    [favorBtn setImage:image forState:UIControlStateNormal];
    favorBtn.showsTouchWhenHighlighted=YES;
    [favorBtn  addTarget:self action:@selector(showFavorScene) forControlEvents:UIControlEventTouchUpInside];
    [toolsview addSubview:favorBtn];  
#if InHouseDistribution
    UIButton* subscribBtn = [[UIButton alloc] initWithFrame:CGRectMake(88, 15, 60,44)];
#else
    UIButton* subscribBtn = [[UIButton alloc] initWithFrame:CGRectMake(68, 15, 60,44)];
#endif
    UIImage *sub_image=[UIImage imageNamed:@"subscribe_white.png"];
    [subscribBtn setImage:sub_image forState:UIControlStateNormal];
    subscribBtn.showsTouchWhenHighlighted=YES;
    [subscribBtn  addTarget:self action:@selector(showSubscribeScene) forControlEvents:UIControlEventTouchUpInside];
    [toolsview addSubview:subscribBtn];
//    UIButton* feedBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(128, 15, 60,44)];
//    UIImage *feed_image=[UIImage imageNamed:@"vip_white.png"];
//    [feedBackBtn setImage:feed_image forState:UIControlStateNormal];
//    feedBackBtn.showsTouchWhenHighlighted=YES;
//    [feedBackBtn  addTarget:self action:@selector(showGalleryScene) forControlEvents:UIControlEventTouchUpInside];
//    [toolsview addSubview:feedBackBtn]; 
//    [feedBackBtn release];
#if InHouseDistribution

#else
    UIButton* vipBtn = [[UIButton alloc] initWithFrame:CGRectMake(128, 15, 60,44)];
    UIImage *vip_image=[UIImage imageNamed:@"vip_white.png"];
    [vipBtn setImage:vip_image forState:UIControlStateNormal];
    vipBtn.showsTouchWhenHighlighted=YES;
    [vipBtn  addTarget:self action:@selector(showVipScene) forControlEvents:UIControlEventTouchUpInside];
    self.toVipBtn=vipBtn;
    [toolsview addSubview:vipBtn];
    [vipBtn release];
#endif
#if InHouseDistribution
    UIButton* settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(168, 15, 60,44)];
#else
    UIButton* settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(188, 15, 60,44)];
#endif
    UIImage *setting_image=[UIImage imageNamed:@"setting_white.png"];
    [settingBtn setImage:setting_image forState:UIControlStateNormal];
    settingBtn.showsTouchWhenHighlighted=YES;
    [settingBtn  addTarget:self action:@selector(showSettingScene) forControlEvents:UIControlEventTouchUpInside];
    [toolsview addSubview:settingBtn];
#if InHouseDistribution
    UIButton* aboutBtn = [[UIButton alloc] initWithFrame:CGRectMake(248, 15, 60,44)]; 
#else
    UIButton* aboutBtn = [[UIButton alloc] initWithFrame:CGRectMake(248, 15, 60,44)]; 
#endif
    UIImage *about_image=[UIImage imageNamed:@"about_white.png"];
    [aboutBtn setImage:about_image forState:UIControlStateNormal];
    aboutBtn.showsTouchWhenHighlighted=YES;
    [aboutBtn  addTarget:self action:@selector(showAboutScene) forControlEvents:UIControlEventTouchUpInside];
    [toolsview addSubview:aboutBtn]; 
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [channel_list count];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"myBasecell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *views = [cell subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    
    NSString *displayMode=[[NSUserDefaults standardUserDefaults] objectForKey:@"displayMode"];
    UIImageView *cellbackground_image;
    if(displayMode==nil||[displayMode isEqualToString:@"日间模式"]){
        cellbackground_image=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cellbackground.png"]];
    }else{
        cellbackground_image=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cellbackground_dark.png"]];
    }
    cell.backgroundView = cellbackground_image;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redarrow.png"]];
    image.frame = CGRectMake(300, 15, 11, 12);
    [cell addSubview:image];
    
    NewsChannel *channelAtIndex = [self.channel_list objectAtIndex:indexPath.row];
    int channel_numberAtIndex=[[self.channel_read_list objectAtIndex:indexPath.row] intValue];
    
    UILabel* labtext = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 30)];
    labtext.backgroundColor = [UIColor clearColor];
    labtext.text = channelAtIndex.title;
    labtext.font = [UIFont fontWithName:@"system" size:15];
    [cell addSubview:labtext];
    UIImageView* mv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 15, 24)];
    mv.image = [UIImage imageNamed:@"flag.png"];
    [cell addSubview:mv];
    
    
    
    UILabel* labNum = [[UILabel alloc] initWithFrame:CGRectMake(280, 10, 15, 15)];
    labNum.backgroundColor = [UIColor clearColor];
    labNum.textColor = [UIColor whiteColor];
    labNum.textAlignment=NSTextAlignmentCenter;
    labNum.font = [UIFont fontWithName:@"Arial" size:9];
    [cell addSubview: labNum];
    
    
    if(channel_numberAtIndex>0&&[labNum.text intValue]!=channel_numberAtIndex){
        mv.hidden = NO;
        labNum.text = [NSString stringWithFormat:@"%d",channel_numberAtIndex];
    }else{
        mv.hidden = YES;
    }
    if(channelAtIndex.imgPath != nil){
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSString* pathImg = [CommonMethod fileWithDocumentsPath:[[channelAtIndex.imgPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent]];
    if([fm fileExistsAtPath:pathImg]){
        UIImageView* uiv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
        uiv.image = [[UIImage alloc] initWithContentsOfFile:pathImg];
        [cell addSubview:uiv];       
    }
    }else{
        UIImageView* uiv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
        uiv.image = [UIImage imageNamed:@"Icon.png"];
        [cell addSubview:uiv];
    }

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击调整
    [self hideToolPannel];
    int selected_index=0;
    NSMutableArray *xdailyitem_list= [AppDelegate.db GetNewsByChannelID:((NewsChannel *)[self.channel_list objectAtIndex:indexPath.row]).channel_id];
    if([xdailyitem_list count]>0&&!((XDailyItem *)[xdailyitem_list objectAtIndex:0]).isRead){
        XDailyItem * daily = [xdailyitem_list objectAtIndex:selected_index];
        NSString* url=[daily.pageurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        NSString* filename=[[url lastPathComponent] stringByDeletingPathExtension];
        NSLog(@"%@",[[url lastPathComponent] stringByDeletingPathExtension]);
        if(![filename isEqualToString:@"index"]){
            ExpressPlusViewController *aController = [[ExpressPlusViewController alloc] init];
            aController.type=@"file";
            aController.siblings=xdailyitem_list;
            aController.index=0;
            aController.baseURL=@"";
            aController.channel_title=((NewsChannel *)[self.channel_list objectAtIndex:indexPath.row]).title;
            XDailyItem * daily = [xdailyitem_list objectAtIndex:selected_index];
            daily.isRead  = YES;
            [AppDelegate.db ModifyDailyNews:daily];
            [AppDelegate.db SaveDb];
            [self.navigationController pushViewController:aController animated:YES];
        }else{
            NewsListPlusViewController *aController = [[NewsListPlusViewController alloc] init];
            aController.type=@"file";
            aController.siblings=xdailyitem_list;
            aController.index=0;
            aController.baseURL=@"";
            aController.channel_title=((NewsChannel *)[self.channel_list objectAtIndex:indexPath.row]).title;
            aController.item_title=aController.channel_title;
            daily.isRead  = YES;
            [AppDelegate.db ModifyDailyNews:daily];
            [AppDelegate.db SaveDb];
            [self.navigationController pushViewController:aController animated:YES];
        }
    }else{
        XdailyItemViewController *aController = [[XdailyItemViewController alloc] init];
        NewsChannel *channelAtIndex = [self.channel_list objectAtIndex:indexPath.row];
        aController.channel_title = channelAtIndex.title;
        aController.channel_id = channelAtIndex.channel_id;
        aController.channel=channelAtIndex;
        [self.navigationController pushViewController:aController animated:YES];
    }
}

-(void)loadPictures{
        NSMutableArray *imgnews=[AppDelegate.db GetImgNews];
            if([imgnews count]>0){
                NSMutableArray *pic_news_array=[[NSMutableArray alloc] initWithCapacity:[imgnews count]];
                self.scrollview.contentSize=CGSizeMake(self.scrollview.frame.size.width * [imgnews count], self.scrollview.frame.size.height);
                for(int i=0;i<[imgnews count];i++){
                    XDailyItem * item=(XDailyItem *)[imgnews objectAtIndex:i];
                    if(item.attachments!=nil){
                        NSArray* tmpArray=[item.attachments componentsSeparatedByString:@";"];
                        NSString *picturefilename=[[[tmpArray objectAtIndex:0]  stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent];
                        NSString* url = [NSString stringWithFormat:@"%@%@",KXinhuaUrl,[item.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
                        NSString* filePath = [[[CommonMethod fileWithDocumentsPath:[url lastPathComponent]] stringByDeletingPathExtension] stringByAppendingString:@"/"];
                        NSLog(@"filePath  %@",item.attachments);
                        NSString *imgURL=[[filePath stringByAppendingString:@"Imgs/"] stringByAppendingString:picturefilename];
                        NSString* filename=[[item.pageurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] lastPathComponent];
                        NSString *articleURL=[filePath stringByAppendingString:filename];
                        PictureNews *pic_news=[[PictureNews alloc]init];
                        pic_news.picture_title=item.title;
                        pic_news.picture_url=imgURL;
                        pic_news.articel_url=articleURL;
                        [pic_news_array addObject:pic_news];
                        NSLog(@"%@",pic_news.picture_url);
                        UIImage *img=[[UIImage alloc] initWithContentsOfFile:pic_news.picture_url];
                        img=[img scaleToSize:CGSizeMake(320, 200)];
                        UIButton *btn=[[UIButton alloc] init];
                        btn.backgroundColor=[UIColor colorWithPatternImage:img];
                        btn.tag=i;
                        [btn addTarget:self action:@selector(showArticle:) forControlEvents:UIControlEventTouchUpInside];
                        CGRect frame = self.scrollview.frame;
                        frame.origin.x = frame.size.width * i;
                        frame.origin.y = 0;
                        btn.frame = frame;
                        [self.scrollview addSubview:btn];
                    }         
                }
                self.picturenews_array=nil;
                self.picturenews_array=pic_news_array;      
                self.pagecontrol.numberOfPages=[self.picturenews_array count];
                self.picTitleLabel.text=((PictureNews *)[self.picturenews_array objectAtIndex:0]).picture_title;
            }
}

-(void)showArticle:(id)sender{
    [self hideToolPannel];
    self.pic_index=((UIButton *)sender).tag;
    PicturePlusViewController *aController = [[PicturePlusViewController alloc] init];  
    aController.siblings=self.picturenews_array;
    aController.baseURL=@"";
    aController.index=self.pic_index;
    aController.type=@"file";  
    aController.channel_title=@"图片新闻";
    [self.navigationController pushViewController:aController animated:YES];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControlUsed = NO;
}

- (void)changePage:(id)sender {
    int page = self.pagecontrol.currentPage;
    CGRect frame = self.scrollview.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollview scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

-(void)AllZipFinished{
    [self doneLoadingTableViewData];
}
- (void)fetchUpdate
{
    [self GetdatafromWebToDb];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)reloadTableViewDataSource{
    [self fetchUpdate];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{	
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
}
	
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	if(scrollView==self.table){
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }else{
        if (pageControlUsed) {
            return;
        }
        CGFloat pageWidth = self.scrollview.frame.size.width;
        int page = floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(page>=0&&page<[self.picturenews_array count]){
            self.pagecontrol.currentPage = page;
            PictureNews *pic_news=[self.picturenews_array objectAtIndex:page];
            self.picTitleLabel.text=pic_news.picture_title; 
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(scrollView==self.table){
	   [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
}
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

-(void)update{

    //[self hideToolPannel];
    NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
    if(setdate== NULL){
        setdate=[NSString stringWithFormat:@"%d",30];
    }
    int retainCount=[setdate intValue];
        NSMutableArray* item2Delete= [AppDelegate.db DelNewsByRetainCount:retainCount];
        for (XDailyItem* daily   in item2Delete) {
            NSString* url = [daily.zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            NSString* fileName = [[url lastPathComponent] stringByDeletingPathExtension] ;
            NSString* filePath = [CommonMethod fileWithDocumentsPath:fileName];
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager removeItemAtPath:filePath error:nil];
        }
        int unReadCount=[AppDelegate.db GetUnReadCount];
        
        NSMutableArray *channel_list_temp=[[NSMutableArray alloc]init];
        NSMutableArray *array=[AppDelegate.db ChannelsSubscrib];
        if([array count]>0){
            for(NewsChannel *channel in array){
                if(channel.generate.intValue==2){
                    
                }else{
                    [channel_list_temp addObject:channel];
                }
                
            }
        }
        
        NSMutableArray *read_list=[[NSMutableArray alloc]init];
        for(NewsChannel *channel in channel_list_temp){
            int unReadCount=[AppDelegate.db GetUnReadCountByChannelId:channel.channel_id];
            [read_list addObject:[NSNumber numberWithInteger:unReadCount]];
        }
            if(unReadCount>0){
                unread_inbox.hidden=NO;
                unread_inbox.badgeText=[NSString stringWithFormat:@"%d",unReadCount];
                [unread_inbox setNeedsDisplay];
            }else{
                unread_inbox.hidden=YES;
            }
            self.channel_list=nil;
            self.channel_list=channel_list_temp;
            self.channel_read_list=nil;
            self.channel_read_list=read_list;
            [self.table reloadData];
}
-(void)updateWithWeb{
    if([[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode]!=nil){
        self.toVipBtn.enabled=false;
    }else{
        self.toVipBtn.enabled=true;
    }
    [self GetdatafromWebToDb];
}

- (BOOL)shouldAutorotate
{ 
    return NO;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)viewDidUnload
{
    [timer invalidate];
    timer = nil;
    [super viewDidUnload];
    
}
@end
