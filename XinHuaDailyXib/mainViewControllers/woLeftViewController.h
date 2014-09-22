//
//  woLeftViewController.h
//  TestSwipeView
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsManagerDelegate.h"
#import "NewsManager.h"
#import "ChannelDataSource.h"

@interface woLeftViewController : UIViewController<NewsManagerDelegate>
@property(nonatomic,strong)UITableView *channelTableView;
@property(nonatomic,strong)ChannelDataSource *dataSource;
-(void)setChannelSource:(ChannelDataSource *)channelSource;
-(void)reloadChannels;
@end
