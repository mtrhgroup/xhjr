//
//  FavorBoxViewController.h
//  XinHuaNewsIOS
//
//  Created by apple on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FavorBoxViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
   
}
@property (strong, nonatomic) NSMutableArray *favor_list;
@property (nonatomic,retain)  NSMutableArray* titleCont;
@property (nonatomic,retain)  NSMutableArray* requestStr;
@property (nonatomic,retain) NSString *favorTitle;
@property (nonatomic,retain) UITableView* table;
@property (nonatomic,retain)UIView *emptyinfo_view;
@end


