//
//  WelcomeViewController.h
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XinHuaAppDelegate.h"
#import "ASIHTTPRequestDelegate.h"
/*
 * USE TASK:  
 *    NewsBindingServerTask
 *    NewsDownloadImgTask
 */

@interface WelcomeViewController : UIViewController<ASIHTTPRequestDelegate>
@property(assign,nonatomic)UINavigationController *mainViewController;
@property(retain,nonatomic)UIImageView *subImg;
@end
