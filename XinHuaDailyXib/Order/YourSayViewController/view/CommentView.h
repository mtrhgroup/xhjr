//
//  CommentView.h
//  YourOrder
//
//  Created by 胡世骞 on 14/11/25.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommentViewClickDelegate <NSObject>

- (void)commentViewClick;

@end
@interface CommentView : UIView
//@property (nonatomic,assign)id<CommentViewClickDelegate>delegate;
- (id)initWithHintString:(NSString*)placeholder delegate:(id)delegate frame:(CGRect)frame;
@end