//
//  TileCell.h
//  ;
//
//  Created by apple on 14/10/11.
//
//

#import <UIKit/UIKit.h>
#import "Article.h"
typedef NS_ENUM(NSInteger, TimeShowType)
{
    None = 0,
    Normal_Date = 1,
    Wraped_Date = 2
    
};
@interface TileCell : UITableViewCell
@property(nonatomic,strong)Article *article;
@property(nonatomic,assign)TimeShowType type;
-(float)preferHeight;
@end
