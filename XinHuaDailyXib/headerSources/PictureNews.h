//
//  PictureNews.h
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XDailyItem.h"
#import "PictureView.h"
@interface PictureNews : XDailyItem
@property(nonatomic, strong) NSString *picture_title;
@property(nonatomic, strong) PictureView *picture_view;
@property(nonatomic, strong) NSString *articel_url;
@property(nonatomic,strong)NSString *picture_url;
-(id)initWithXdaily:(XDailyItem *)xdaily;
@end
