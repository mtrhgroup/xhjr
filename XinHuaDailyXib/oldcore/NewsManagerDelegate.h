//
//  NewsManagerDelegate.h
//  XinHuaDailyXib
//
//  Created by apple on 13-2-27.
//
//
#import <Foundation/Foundation.h>
@class XDailyItem;
@protocol NewsManagerDelegate <NSObject>
@optional
-(void)didReceiveNewsHeaders:(NSArray *)items;
-(void)didReceiveNewsContent:(XDailyItem *)xdaily;
-(void)didReceiveChannelIconFile:(NSString *)filePath;
-(void)didChangeNewsStatus:(XDailyItem *)xdaily;
-(void)didReceivedPicture:(NSString *)localpath;
-(void)didReceiveMoreNewsItems:(NSArray *)items;
@end
