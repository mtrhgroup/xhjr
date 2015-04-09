//
//  NewsZipDownloadTask.h
//  CampusNewsLetter
//
//  Created by apple on 13-1-8.
//
//

#import <Foundation/Foundation.h>
@interface NewsDownloadTask : NSObject
+(void)downloadChannelList;
+(void)downloadXdailyOfChannelId:(NSString *)channel_id topN:(NSString *)topN;
+(void)downloadIconOfChannel:(NewsChannel *)channel;
+(void)downloadLatestXdaiyOfEachChannel: (NSArray *)channels;
+(void)downloadXdaily:(XDailyItem *)xdaily;
@end
