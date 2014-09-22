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
    @package
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
    NSString* _summary;
    NSString* _thumbnail;
    NSString* _pn;
    
}
@property(nonatomic,strong)NSNumber*      item_id;
//名字
@property(nonatomic,strong)NSString*      title;
//
@property(nonatomic,strong)NSString*      pageurl;
//
@property(nonatomic,strong)NSString*      zipurl;
//时间
@property(nonatomic,strong)NSString*      dateString;
//
@property(nonatomic,strong)NSString*      key;
//已读未读

@property(nonatomic)BOOL           isRead;
//所属频道id
@property(nonatomic,strong)NSString*      channelId;
//所属频道名称
@property(nonatomic,strong)NSString*      channelTitle;

@property(nonatomic,strong)NSString*      attachments;
@property(nonatomic,strong)NSString*      summary;
@property(nonatomic,strong)NSString*      thumbnail;
@property(nonatomic,strong)NSString*      homenum;
@property(nonatomic,strong)NSString* pn;

+(XDailyItem*)XDailyItemFromDailyNews:(DailyNews*) news;
-(NSString *)localPath;

@end
