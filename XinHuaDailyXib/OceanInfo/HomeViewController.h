//
//  AggregateChannelViewController.h
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import <UIKit/UIKit.h>
#import "ChannelHeader.h"
#import "ChannelViewController.h"
#import "TipTouchView.h"
@interface HomeViewController : ChannelViewController<UITableViewDelegate,HeaderViewDelegate,UITableViewDataSource,TipTouchViewDelegate>
@property(nonatomic,strong)Channel *channel;

@end
