//
//  HomeHeader.h
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-16.
//
//

#import <UIKit/UIKit.h>
#import "TouchViewDelegate.h"
#import "Article.h"
@interface HomeHeader : UIView<UIScrollViewDelegate>
@property(nonatomic,strong)NSArray *articles;
@property(nonatomic,strong)id<TouchViewDelegate> delegate;
@end
