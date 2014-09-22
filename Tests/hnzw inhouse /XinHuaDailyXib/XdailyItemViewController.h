//
//  XdailyItemViewControllerViewController.h
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "NewsChannel.h"



@interface XdailyItemViewController : UIViewController <EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray *xdailyitem_list;
@property(nonatomic,copy)NSString* channel_id;
@property(nonatomic,retain)NSString* channel_title; 
@property(nonatomic,retain)NewsChannel *channel;
@property (retain, nonatomic) UITableView *table;
@property (nonatomic,retain)UILabel *emptyinfo_label;

@end
