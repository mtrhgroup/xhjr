//
//  CollectorCell.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>

@interface CollectorCell : UITableViewCell
@property(nonatomic,strong)Article *article;
@property(nonatomic,assign)BOOL is_editable;
@end
