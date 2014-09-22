//
//  NewsInBoxViewController.h
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewsInBoxViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

}

@property (nonatomic, strong) NSMutableArray *xdailyitem_list;
@property (nonatomic, strong) UITableView* table;
@end
