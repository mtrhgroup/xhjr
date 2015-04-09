//
//  UITopicCell.h
//  XinHuaDailyXib
//
//  Created by 张健 on 15-2-9.
//
//

#import <UIKit/UIKit.h>
#import "Channel.h"
@interface TopicCell : UITableViewCell
@property(nonatomic,strong)Channel *top_channel;
+(CGFloat)preferHeight;
@end
