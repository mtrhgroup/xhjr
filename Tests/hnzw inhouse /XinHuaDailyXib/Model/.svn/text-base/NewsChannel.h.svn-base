//
//  NewsLabel.h
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//
//  NewsChannel.h
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Label;
@interface NewsChannel : NSObject
//来自服务器的id
@property(nonatomic,copy)NSString* channel_id;
//名字
@property(nonatomic,copy)NSString* title;
//描述
@property(nonatomic,copy)NSString* description;
//权限
@property(nonatomic,copy)NSNumber* level;
//是否订阅
@property(nonatomic,copy)NSNumber *subscribe;
//客户顺序编码
@property(nonatomic,copy)NSNumber*  custom_order;

@property(nonatomic,copy)NSString* imgPath;

@property(nonatomic,copy)NSNumber* generate;

@property(nonatomic,copy)NSNumber* sort;

+(NewsChannel*)NewsChannelFromLabel:(Label*) label;
@end



