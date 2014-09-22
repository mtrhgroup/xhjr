//
//  NewsCommunicator.h
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import <Foundation/Foundation.h>

@interface NewsNetOperator : NSObject
-(NSArray *)downloadXdailyWithChannelId:(NSString *)channel_id topN:(NSString *)topN;
-(NSArray *)downloadChannelList;
-(NSString *)downloadIconfileWithChannelAndReturnFilepath:(NewsChannel *)channel;
-(BOOL)downloadXdaily:(XDailyItem *)xdaily;
-(BOOL)downloadPictureWithLocalpath:(NSString *)localpath neturl:(NSString *)neturl;
@end
