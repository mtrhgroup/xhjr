//
//  DailyListViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>
#import "NLMainTableViewController.h"
#import "TipTouchView.h"
@interface FirstDailyViewController :NLMainTableViewController<UITableViewDataSource, UITableViewDelegate,TipTouchViewDelegate>
@property(nonatomic,strong)Service *service;
@end
