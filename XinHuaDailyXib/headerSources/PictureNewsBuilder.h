//
//  PictureNewsBuilder.h
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import <Foundation/Foundation.h>
@class PictureNews;
@class XDailyItem;
@interface PictureNewsBuilder : NSObject
+(PictureNews *)picturenewsFromXDailyItem:(XDailyItem *)item;
@end
