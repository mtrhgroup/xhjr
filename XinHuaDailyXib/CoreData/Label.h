//
//  Label.h
//  XinHuaDailyXib
//
//  Created by apple on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#define LabelName @"Label"


@interface Label : NSManagedObject

@property (nonatomic, retain) NSString * channelID;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * des;
@property (nonatomic, retain) NSNumber * generate;
@property (nonatomic, retain) NSString * imgPath;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * sub;
@property (nonatomic, retain) NSNumber * sort;
@property(nonatomic,strong)NSNumber *homenum;

@end
