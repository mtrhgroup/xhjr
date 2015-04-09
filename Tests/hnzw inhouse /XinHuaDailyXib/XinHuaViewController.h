//
//  XinHuaViewController.h
//  XinHuaDailyXib
//
//  Created by zhang jun on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FavorBoxViewController.h"
#import "XDAboutViewController.h"
#import "ASIHTTPRequest.h"
#import "SubscribeViewController.h"
#import "CommonMethod.h"
#import "ExpressMarquee.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequestDelegate.h"
#import "ExpressPlusViewController.h"
#import "NewsListPlusViewController.h"
#import "XdailyItemViewController.h"
/*
 * USE Task:
 *     NewsDownloadAllTask
 */

@interface XinHuaViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    
    UINavigationBar* bar;
    UIScrollView* scrollview;
    UIPageControl *pagecontrol;
    NSMutableArray* picArr;
    UITableView* table;
    NSMutableArray* channel_list;
    UIView* tools_view;
    UILabel* picTitleLabel;
}

@property (nonatomic,retain) UIPageControl* pagecontrol;
@property (nonatomic,retain) UIScrollView* scrollview;
@property (nonatomic,retain) UITableView* table;
@property (retain, atomic) NSMutableArray *channel_list;
@property (retain, atomic) NSMutableArray *channel_read_list;
@property (retain,nonatomic) UIView* tools_view;

@property (retain,nonatomic) NSMutableArray *picturenews_array;
@property (nonatomic,retain) UILabel* picTitleLabel;
@property(retain,nonatomic)UIButton *toVipBtn;
@property  int pic_index;
@property(nonatomic,retain)EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic,retain)ExpressMarquee *expressMarquee;
@property(nonatomic,retain)ExpressPlusViewController *expressPlusViewController;
@property(nonatomic,retain)NewsListPlusViewController *newsListPlusViewController;
@property(nonatomic,retain)XdailyItemViewController *xdailyItemViewController;



//pagecontrol页面改变
-(void)changePage:(id)sender;

//从数据库读取数据
-(void)getDataFromDB;

//从网络读取数据
-(void)GetdatafromWebToDb;

//通过栏目id获取数据
-(void)GetXdailysFromWebToDb: (NSString *)channel_id;

-(void)makeToolPannel;

-(void)menu;
-(void)update;
-(void)updateWithWeb;
@end
