//
//  SubscribeViewController.h
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscribeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView* table;
}


@property (strong, nonatomic) NSMutableArray *channel_list;
@property (nonatomic,retain) UITableView* table;


- (void)changeStatus:(id)sender;
- (void)returnBtn:(id)sender;

@end


