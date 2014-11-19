//
//  CommentCell.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/17.
//
//

#import <UIKit/UIKit.h>
#import "Comment.h"
@interface CommentCell : UITableViewCell
@property(nonatomic,strong)Comment *comment;
-(float)preferHeight;
@end
