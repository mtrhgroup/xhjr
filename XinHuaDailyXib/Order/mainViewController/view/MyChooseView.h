//
//  MyChooseView.h
//  YourOrder
//
//  Created by 胡世骞 on 14/11/19.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GetMyChooseInputDelegate <NSObject>

- (void)getInputTitle:(NSString*)title andContent:(NSString*)content;

@end
@interface MyChooseView : UIView
@property (nonatomic,assign)id<GetMyChooseInputDelegate> delegate;
@end