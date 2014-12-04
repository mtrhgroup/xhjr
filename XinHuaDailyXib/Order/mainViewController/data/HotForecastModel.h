//
//  HotForecastModel.h
//  order
//
//  Created by 胡世骞 on 14/11/15.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HotForecastModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *creatTime;
@property (nonatomic,copy)NSString *noticeTime;
@property (nonatomic,copy)NSString *user;
@property (nonatomic,copy)NSString *participate;
@property (nonatomic,copy)NSString *focus_count;
@property (nonatomic,copy)NSString *comment_count;

@property (nonatomic,assign,readonly)CGSize contentSize;
@end
