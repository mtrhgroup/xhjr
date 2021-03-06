//
//  XDailyItem.m
//  XDailyNews
//
//  Created by peiqiang li on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "XDailyItem.h"
#import "DailyNews.h"

@implementation XDailyItem
@synthesize      item_id=_item_id;
@synthesize      title = _title;
@synthesize      pageurl = _pageurl;
@synthesize      zipurl = _zipurl;
@synthesize      dateString = _dateString;
@synthesize      key = _key;
@synthesize      isRead = _isread;
@synthesize      channelId;
@synthesize      channelTitle;
@synthesize attachments;
- (void)dealloc
{
    [_item_id release];
    [_title release];
    [_pageurl release];
    [_zipurl release];
    [_dateString release];
    [_key release];
    [channelId release];
    [channelTitle release];
    [attachments release];
    [super dealloc];
     
}
+(XDailyItem*)XDailyItemFromDailyNews:(DailyNews*) news
{
    XDailyItem * item = [[[XDailyItem alloc] init] autorelease];
     
    item.title = news.newsTitle;
    item.dateString = news.newsDate;
    item.pageurl = news.pageurl;
    item.zipurl = news.zipurl;
    item.key = news.key;
    item.channelId = news.channelid;
    item.isRead = [news.read boolValue] ;
    item.channelTitle=news.channeltitle;
    item.item_id = news.item_id;
    item.attachments = news.attachments;
    return item;
    
}
@end
