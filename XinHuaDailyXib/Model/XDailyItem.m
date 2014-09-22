//
//  XDailyItem.m
//  XDailyNews
//
//  Created by peiqiang li on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "XDailyItem.h"
#import "DailyNews.h"
#import "CommonMethod.h"
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
@synthesize      summary=_summary;
@synthesize      thumbnail=_thumbnail;
@synthesize      homenum=_homenum;
@synthesize      pn=_pn;
@synthesize attachments;

-(NSString *)localPath{
    NSString* path_url = [_zipurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString* url=[_pageurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString* filename=[url lastPathComponent];
    NSString* dirName = [path_url lastPathComponent];
    NSString* filePath =[[CommonMethod fileWithDocumentsPath:dirName] stringByDeletingPathExtension];
    NSString* urlStr=[NSString stringWithFormat:@"%@/%@",[filePath stringByDeletingPathExtension],filename];
    return  urlStr;
}
+(XDailyItem*)XDailyItemFromDailyNews:(DailyNews*) news
{
    __autoreleasing  XDailyItem * item = [[XDailyItem alloc] init];
     
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
    item.summary=news.summary;
    item.thumbnail=news.thumbnail;
    item.pn=news.pn;
    return item;
    
}
@end
