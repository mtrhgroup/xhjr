//
//  XDailyItem.h
//  XDailyNews
//
//  Created by peiqiang li on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDailyItem;
@class DailyNews;
@interface XDailyItem : NSObject
{
    NSNumber*       _item_id;
    NSString*       _title;
    NSString*       _pageurl;
    NSString*       _zipurl;
    NSString*       _dateString;
    NSString*       _key;
    BOOL _isread ;
    NSString* _channelId;
    NSString*      _channelTitle;
    NSString* _attachments;
    
}
@property(nonatomic,copy)NSNumber*      item_id;
//名字
@property(nonatomic,copy)NSString*      title;
//
@property(nonatomic,copy)NSString*      pageurl;
//
@property(nonatomic,copy)NSString*      zipurl;
//时间
@property(nonatomic,copy)NSString*      dateString;
//
@property(nonatomic,copy)NSString*      key;
//已读未读

@property(nonatomic)BOOL           isRead;
//所属频道id
@property(nonatomic,copy)NSString*      channelId;
//所属频道名称
@property(nonatomic,copy)NSString*      channelTitle;

@property(nonatomic,copy)NSString*      attachments;

+(XDailyItem*)XDailyItemFromDailyNews:(DailyNews*) news;

@end
