//
//  NewsDownloadImgTask.h
//  CampusNewsLetter
//
//  Created by apple on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * notification : KPictureOK           "动态启动图准备完毕"      userInfo:data  (NSString *) "动态启动图的路径"       
 */
@interface NewsDownloadImgTask : NSObject
+(NewsDownloadImgTask *)sharedInstance;
-(void)execute;
@end
