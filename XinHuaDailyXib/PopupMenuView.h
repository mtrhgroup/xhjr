//
//  KidsPopupMenuView.h
//  kidsgarden
//
//  Created by apple on 14/6/25.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopupMenuDelegate <NSObject>
-(void)favor;
-(void)unfavor;
-(void)font;
-(void)share;
@end
@interface PopupMenuView : UIView
@property(nonatomic,assign)BOOL favor_status;
@property(nonatomic,assign)id<PopupMenuDelegate> delegate;
-(void)show;
-(void)hide;

@end
