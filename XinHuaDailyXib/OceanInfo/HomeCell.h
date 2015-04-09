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
@property(nonatomic,strong)Channel *top_channel;
+(CGFloat)preferHeight;
@end
