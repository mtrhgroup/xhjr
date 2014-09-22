//
//  DailyNews.h
//  XinHuaDailyXib
//
//  Created by apple on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#define KDailyNewsData @"DailyNews"

@interface DailyNews : NSManagedObject

@property (nonatomic, retain) NSString * attachments;
@property (nonatomic, retain) NSString * channelid;
@property (nonatomic, retain) NSString * channeltitle;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSNumber * download;
@property (nonatomic, retain) NSNumber * item_id;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * newsDate;
@property (nonatomic, retain) NSString * newsTitle;
@property (nonatomic, retain) NSString * pageurl;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * zipurl;
@property (nonatomic,retain)  NSString *summary;
@property(nonatomic,retain)NSString *thumbnail;
@property(nonatomic,retain)NSString *pn;


@end
