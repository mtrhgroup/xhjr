//
//  SettingViewController.h
//  XinHuaDailyXib
//
//  Created by 耀龙 马 on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
    UITableView* table;
    UILabel* labcell;
    
    
}


@property (nonatomic,retain) UITableView* table;
@property (nonatomic,retain)UILabel *labBuff;
@property (nonatomic,retain)UILabel *labFont;
@property (nonatomic,retain)UILabel *byteslostLabel;
@property (retain,nonatomic)UIAlertView *waitingAlert;

@end
