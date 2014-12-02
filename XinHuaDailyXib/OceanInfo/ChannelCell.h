//
//  ChannelCell.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/21.
//
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"
@protocol ChannelCellDelegate <NSObject>
-(void)fatherCloseBtnClicked;
-(void)tagItemClickedWithTag:(NSString *)tag;
@end

@interface ChannelCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)MenuItem *menu_item;
@property(nonatomic,assign)id<ChannelCellDelegate> delegate;
+(CGFloat)preferHeightWithMenuItem:(MenuItem *)menu_item;
@end
