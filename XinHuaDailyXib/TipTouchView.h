//
//  TipTouchView.h
//  XinHuaDailyXib
//
//  Created by apple on 14/12/4.
//
//

#import <UIKit/UIKit.h>
@protocol TipTouchViewDelegate <NSObject>
-(void)tipTouchViewClicked;
@end
@interface TipTouchView : UIView
@property(nonatomic,assign)id<TipTouchViewDelegate>delegate;
-(void)hide;
-(void)show;
@end
