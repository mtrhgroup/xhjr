//
//  NewsCoreDataOperator.h
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//

#import <Foundation/Foundation.h>
@class Label;
@class NewsChannel;
@class XDailyItem;
@class DailyNews;

@interface NewsCoreDataOperator : NSObject{
    NSManagedObjectContext *managedObjectContext;
}
-(NSMutableArray*)GetImgNews;
-(NSMutableArray*)allChannels;
-(NSMutableArray*)GetNewsByChannelID:(NSString *) channelId;
-(void)saveChannel:(NewsChannel *)item;
-(void)saveXDailyItem:(XDailyItem*)item;
-(void)ModifyDailyNews:(XDailyItem*)daily;

- (BOOL)SaveDb;
@end
