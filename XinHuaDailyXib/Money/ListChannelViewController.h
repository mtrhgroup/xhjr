//
//  ListChannelViewController.h
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-10.
//
//

#import <UIKit/UIKit.h>
#import "LeafChannelViewController.h"
#import "ChannelHeader.h"
@interface ListChannelViewController :LeafChannelViewController<UITableViewDelegate,HeaderViewDelegate,UITableViewDataSource>

@end
