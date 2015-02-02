//
//  HomeCell.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/27.
//
//

#import <UIKit/UIKit.h>
#import "Article.h"
@interface HomeCell : UITableViewCell
@property(nonatomic,strong)Article *article;
@property(nonatomic,assign)BOOL is_on_home;
+(CGFloat)preferHeight;
@end
