//
//  ListFooterView.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/2.
//
//

#import <UIKit/UIKit.h>
#import "TouchViewDelegate.h"
typedef NS_ENUM(NSInteger, FooterState)
{
    Busy = 0,
    Idle = 1,
    Hide = 2
  
};
@interface ListFooterView : UIView
@property(nonatomic,assign)FooterState state;
@property(nonatomic,assign)id<TouchViewDelegate>delegate;
@end
