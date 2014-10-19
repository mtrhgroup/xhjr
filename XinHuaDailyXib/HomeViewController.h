//
//  AggregateChannelViewController.h
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import <UIKit/UIKit.h>
#import "TouchViewDelegate.h"
#import "ChannelViewController.h"
@interface HomeViewController : ChannelViewController<UITableViewDelegate,TouchViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)Channel *channel;

@end
