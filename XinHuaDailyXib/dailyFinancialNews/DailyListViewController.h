//
//  DailyListViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>
#import "NLMainTableViewController.h"
@interface DailyListViewController :NLMainTableViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)Service *service;
@end
