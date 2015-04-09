//
//  SettingViewController.h
//  XinHuaDailyXib
//
//  Created by 耀龙 马 on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate>{
    
    UITableView* table_view;
    UILabel* labcell;
    
    
}


@property (nonatomic,strong) UITableView* table_view;
@property (nonatomic,strong)UILabel *labBuff;
@property (nonatomic,strong)UILabel *labFont;
@property (nonatomic,strong)UILabel *byteslostLabel;
@property (strong,nonatomic)UIAlertView *waitingAlert;

@end
