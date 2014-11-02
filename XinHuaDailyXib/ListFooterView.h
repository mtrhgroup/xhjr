//
//  ListFooterView.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/2.
//
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, FooterState)
{
    Busy = 0,
    Idle = 1
  
};
@interface ListFooterView : UIView
@property(nonatomic,assign)FooterState state;
@end
