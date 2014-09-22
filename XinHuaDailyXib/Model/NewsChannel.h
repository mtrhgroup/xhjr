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
@property(nonatomic,strong)NSString* channel_id;
//名字
@property(nonatomic,strong)NSString* title;
//描述
@property(nonatomic,strong)NSString* description;
//权限
@property(nonatomic,strong)NSNumber* level;
//是否订阅
@property(nonatomic,strong)NSNumber *subscribe;
//客户顺序编码
@property(nonatomic,strong)NSNumber*  custom_order;

@property(nonatomic,strong)NSString* imgPath;

@property(nonatomic,strong)NSNumber* generate;

@property(nonatomic,strong)NSNumber* sort;

@property(nonatomic,strong)NSDate *timestamp;
@property(nonatomic,strong)UIColor *color;
@property(nonatomic,strong)UIImage *imgArrow;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,strong)NSNumber *homenum;
-(void)stampTime;
-(BOOL)isOld;

+(NewsChannel*)NewsChannelFromLabel:(Label*) label;
@end



