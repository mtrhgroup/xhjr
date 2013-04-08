//
//  Favor.h
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favor : NSManagedObject

@property (nonatomic, retain) NSString * favorid;
@property (nonatomic, retain) NSString * favortitle;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * dailyid;
@property (nonatomic, retain) NSString * dailydate;
@property (nonatomic, retain) NSString * favorDate;
@property (nonatomic, retain) NSString * dailytitle;

@end
