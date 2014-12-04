//
//  CommentModel.h
//  YourOrder
//
//  Created by 胡世骞 on 14/11/25.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommentModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSString *commentContent;
@property (nonatomic,copy)NSString *creatTime;
@property (nonatomic,copy)NSString *literID;

@property (nonatomic,assign,readonly)CGSize commentContentSize;
@end
