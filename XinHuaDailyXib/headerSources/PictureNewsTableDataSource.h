//
//  PictureNewsTableDataSource.h
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import <Foundation/Foundation.h>
#import "NewsheaderDataSource.h"
@class PictureNews;

@interface PictureNewsTableDataSource : NewsheaderDataSource
-(PictureNews *)newsForIndexPath:(NSIndexPath *)indexPath;
@end

extern NSString *PictureNewsTableDidSelectNewsNotification;
