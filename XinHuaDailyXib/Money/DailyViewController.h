//
//  DailyViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/17.
//
//

#import <UIKit/UIKit.h>

@interface DailyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (id)initWithService:(Service *)service date:(NSString *)date;
@end
