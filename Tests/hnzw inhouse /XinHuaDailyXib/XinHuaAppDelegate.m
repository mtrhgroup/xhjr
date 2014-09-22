//
//  XinHuaAppDelegate.m
//  XinHuaDailyXib
//
//  Created by zhang jun on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XinHuaAppDelegate.h"
#import "WelcomeViewController.h"
#import "XinHuaViewController.h"
#import "NewsDbOperator.h"
#import "UserDefaultManager.h"
#import "NewsXmlParser.h"
#import "ExpressNotificationViewController.h"
#import "NewsDefine.h"
#import "NewsUploadTokenTask.h"
#import "NewsBindingServerTask.h"
#import "NewsDownloadExpreesTask.h"
#define KSQLFile @"news.sqlite"

@implementation XinHuaAppDelegate

@synthesize window = _window;
@synthesize startviewController=_startviewController,mainviewController=_mainviewController;
@synthesize db = _db;
@synthesize channel_list_subscribe=_channel_list_subscribe,channel_list=_channel_list,flag=_flag,isSuspended=_isSuspended;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
      _mainviewController = [[UINavigationController alloc] initWithRootViewController:[[XinHuaViewController alloc] init]];
      _startviewController=[[WelcomeViewController alloc] init];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] 
     setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dcoumentpath = ([paths count] > 0)? [paths objectAtIndex:0] : nil;
    NSString*  dbpath = [NSString stringWithFormat:@"%@/%@",dcoumentpath,KSQLFile];
    self.db=nil;
    self.db = [[[NewsDbOperator alloc] initWithFile:dbpath] autorelease];
    if (launchOptions) {           
        //截取apns推送的消息
        NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];   
        NSLog(@"pushInfo %@",pushInfo);
        //获取推送详情        
//        UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:[[[XinHuaViewController alloc] init] autorelease]];
        self.window.rootViewController=_mainviewController;
//        [unc release];
        [self.window makeKeyAndVisible];        
        ExpressNotificationViewController *aExpressController = [[[ExpressNotificationViewController alloc] init] autorelease];
        aExpressController.item_id=[pushInfo objectForKey:@"id"];
        [self.window.rootViewController presentModalViewController:aExpressController animated:YES];
    }else{
        
//        WelcomeViewController *aController=[[[WelcomeViewController alloc] init] autorelease];
        self.window.rootViewController=_startviewController;
        [self.window makeKeyAndVisible];
    }   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    self.isSuspended=YES;
    NSLog(@"applicationWillResignActive %d",self.isSuspended);
    [[NewsUploadTokenTask sharedInstance] clearBadgeOnServer];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName: KEnterForeground
                                                        object: self];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NewsUploadTokenTask sharedInstance] clearBadgeOnServer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.isSuspended=NO;
    NSLog(@"applicationDidBecomeActive %d",self.isSuspended);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%d",application.applicationState);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSLog(@"deviceToken: %@",token);   
    if (token.length > 0)
    {
        [[NewsUploadTokenTask sharedInstance] uploadToken:token];
    }
    
} 
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
	NSLog(@"%@",@"注册通知失败！！！！！！！！！");
    NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError: %@", [[UIApplication sharedApplication] enabledRemoteNotificationTypes] ?
                        @"Notifications were active for this application" :
                        @"Remote notifications were not active for this application", [error localizedDescription]];
    NSLog(@"Error in registration. Error: %@", error); 
	NSLog(@"status = %@",status);
    NSLog(@"%@",@"注册通知失败！！！！！！！！！");
} 

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if(!self.isSuspended)
    {//前台
        [[NewsDownloadExpreesTask sharedInstance] execute:[userInfo objectForKey:@"id"]];
    }else{
       ExpressNotificationViewController *aController = [[[ExpressNotificationViewController alloc] init] autorelease];
       aController.item_id=[userInfo objectForKey:@"id"];
        self.window.rootViewController=_mainviewController;
       [self.window makeKeyAndVisible];
       [self.window.rootViewController presentModalViewController:aController animated:YES];
    }

}
- (void)clearBadgeOnServer{
    NSString* regUrl = [NSString stringWithFormat:KClearBadgeURL,[UIDevice customUdid]];
    regUrl = [regUrl trimSpaceAndReturn];
    NSLog(@"reg = %@",regUrl);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setCompletionBlock:^{
        
        NSData*   responseData = [request responseData];
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        [responseString release];
        [request release];
    }];
    [request setFailedBlock:^{
        NSLog(@"responseString = %@",[request.error localizedDescription]);
        [request release];
    }];
    [request startAsynchronous];
}
- (void)redirectNSLogToDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
@end
