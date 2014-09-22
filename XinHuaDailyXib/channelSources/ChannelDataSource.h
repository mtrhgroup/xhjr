//
//  ChannelDataSource.h
//  XinHuaDailyXib
//
//  Created by apple on 13-3-22.
//
//
#import <Foundation/Foundation.h>
@class NewsChannel;
@interface ChannelDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString *channelheanderText;
@property(nonatomic,strong)NewsChannel *aggr_channel;
-(void)setItems:(NSArray *)items;
-(NSArray *)getItems;
-(void)stampTimeOnChannel:(NewsChannel *)channel;
-(NewsChannel *)newsForIndexPath:(NSIndexPath *)indexPath;

@end
extern NSString *MainChannelTableDidSelectNewsNotification;
extern NSString *NewsChannelTableDidSelectNewsNotification;


