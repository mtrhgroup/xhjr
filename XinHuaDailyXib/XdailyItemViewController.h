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

@property (nonatomic, strong) NSMutableArray *xdailyitem_list;
@property(nonatomic,strong)NSString* channel_id;
@property(nonatomic,strong)NSString* channel_title; 
@property(nonatomic,strong)NewsChannel *channel;
@property (strong, nonatomic) UITableView *table;
@property (nonatomic,strong)UILabel *emptyinfo_label;

@end
