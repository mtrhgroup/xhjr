//
//  LeftViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>
#import "Service.h"
@interface LeftViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)Service *service;
@end
