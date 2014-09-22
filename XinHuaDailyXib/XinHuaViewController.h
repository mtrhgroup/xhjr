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

@property (nonatomic,strong) UIPageControl* pagecontrol;
@property (nonatomic,strong) UIScrollView* scrollview;
@property (nonatomic,strong) UITableView* table;
@property (strong, atomic) NSMutableArray *channel_list;
@property (strong, atomic) NSMutableArray *channel_read_list;
@property (strong,nonatomic) UIView* tools_view;

@property (strong,nonatomic) NSMutableArray *picturenews_array;
@property (nonatomic,strong) UILabel* picTitleLabel;
@property(strong,nonatomic)UIButton *toVipBtn;
@property  int pic_index;
@property(nonatomic,strong)EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic,strong)ExpressMarquee *expressMarquee;
@property(nonatomic,strong)ExpressPlusViewController *expressPlusViewController;
@property(nonatomic,strong)NewsListPlusViewController *newsListPlusViewController;
@property(nonatomic,strong)XdailyItemViewController *xdailyItemViewController;



//pagecontrol页面改变
-(void)changePage:(id)sender;


//从网络读取数据
-(void)GetdatafromWebToDb;


-(void)makeToolPannel;

-(void)menu;
-(void)update;
-(void)updateWithWeb;
@end
