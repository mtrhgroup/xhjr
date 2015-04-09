//
//  ListViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>

@interface TagListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)NSString *tag;
@end
