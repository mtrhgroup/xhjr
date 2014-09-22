//
//  NetStreamStatistics.h
//  CampusNewsLetter
//
//  Created by apple on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetStreamStatistics : NSObject
+(NetStreamStatistics *)sharedInstance;
-(void)appendBytesToDictionary:(int)bytes;
-(void)appendBytesTo3GDictionary:(int)bytes;
-(void)appendBytesToWifiDictionary:(int)bytes;
-(NSString *)thisMonthWifiBytesLost;
-(NSString *)lastMonthWifiBytesLost;
-(NSString *)thisMonthCellBytesLost;
-(NSString *)lastMonthCellBytesLost;
@end
