//
//  NewsAllChannelDownloadTask.h
//  CampusNewsLetter
//
//  Created by apple on 13-1-8.
//
//

#import <Foundation/Foundation.h>
#import "NewsDbOperatorForChildThread.h"
@interface NewsAllChannelDownloadTask : NSObject
+(void)execute;
@end
