//
//  NewsheaderDataSource.h
//  sxtv3
//
//  Created by apple on 13-3-25.
//  Copyright (c) 2013年 xhnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGORefreshTableHeaderView.h"
#import "NewsManagerDelegate.h"
#import "NewsChannel.h"
@interface NewsheaderDataSource : NSObject<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,NewsManagerDelegate>{
    NSString *cellReuseIdentifier;
}
@property(nonatomic,strong)EGORefreshTableHeaderView *refreshheaderview;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NewsChannel *channel;
-(XDailyItem *)newsForIndexPath:(NSIndexPath *)indexPath;
-(void)reloadDataFromCoreData;
-(void)reloadData;
@end
extern NSString *PeriodicalNewsHeaderSelectionNotification;
extern NSString *ExpressNewsHeaderSelectionNotification;
extern NSString *PictureNewsHeaderSelectionNotification;
