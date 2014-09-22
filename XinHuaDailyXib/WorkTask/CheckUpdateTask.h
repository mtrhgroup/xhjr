//
//  CheckUpdateTask.h
//  XinHuaDailyXib
//
//  Created by apple on 13-5-27.
//
//

#import <Foundation/Foundation.h>

@interface CheckUpdateTask : NSObject
+(CheckUpdateTask *)sharedInstance;
-(BOOL)hasNewerVersion;
-(NSString *)newVersion;
-(NSString *)getNewerVersionDescription;
@end
