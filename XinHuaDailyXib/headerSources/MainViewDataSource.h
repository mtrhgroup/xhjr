//
//  MainViewDataSource.h
//  XinHuaDailyXib
//
//  Created by apple on 13-8-15.
//
//

#import <Foundation/Foundation.h>
#import "NewsheaderDataSource.h"
#import "XDailyItem.h"
#import "PictureNews.h"
#import "PictureNewsBuilder.h"
#import "PictureView.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewDataSource : NewsheaderDataSource
@property(nonatomic,strong)EGORefreshTableHeaderView *refreshheaderview;
@property(nonatomic,strong)UITableView *tableview;
-(PictureNews *)newsForIndexPath:(NSIndexPath *)indexPath;
-(void)reloadDataFromCoreData;
-(void)simulatePullHeaderView;
-(void)reloadData;
@end
