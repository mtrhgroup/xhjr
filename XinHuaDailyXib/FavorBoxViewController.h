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
@property (nonatomic,strong)  NSMutableArray* titleCont;
@property (nonatomic,strong)  NSMutableArray* requestStr;
@property (nonatomic,strong) NSString *favorTitle;
@property (nonatomic,strong) UITableView* table;
@property (nonatomic,strong)UIView *emptyinfo_view;
@end


