//
//  XDAboutViewController.h
//  XDailyNews
//
//  Created by peiqiang li on 11-12-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDAboutViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    
    UINavigationBar* bar;
    UITableView* table;
}

@property(nonatomic,strong)  UITableView* table;
@property int mode;
-(void)returnclick:(id)sender;

@end
