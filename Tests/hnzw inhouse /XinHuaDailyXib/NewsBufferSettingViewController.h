//
//  NewsBufferSettingViewController.h
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewsBufferSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
     UIImageView* uivaa;
     UIImageView* uivbb;
     UIImageView* uivcc;
     UITableView* table;
   
}


@property (nonatomic,retain)   UIImageView* uivaa;
@property (nonatomic,retain)   UIImageView* uivbb;
@property (nonatomic,retain)   UIImageView* uivcc;
@property (nonatomic,retain) UITableView* table;

@end
