//
//  PictureNews.m
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureNews.h"

@implementation PictureNews

@synthesize picture_title;
@synthesize picture_view;
@synthesize articel_url;
@synthesize picture_url;
-(id)initWithXdaily:(XDailyItem *)xdaily{
        self = [super init];
        if (self) {
            self.item_id=xdaily.item_id;
            self.title=xdaily.title;
            self.pageurl=xdaily.pageurl;
            self.zipurl=xdaily.zipurl;
            self.dateString=xdaily.dateString;
            self.key=xdaily.key;
            self.isRead=xdaily.isRead;
            self.channelId=xdaily.channelId;
            self.channelTitle=xdaily.channelTitle;
            self.attachments=xdaily.attachments;
            self.summary=xdaily.summary;
            self.thumbnail=xdaily.thumbnail;
        }
        return self;
}
@end
