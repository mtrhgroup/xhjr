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
#import "NewsXmlParser.h"
#import "ExpressNotificationViewController.h"
#import "NewsDefine.h"
#import "NewsUploadTokenTask.h"
#import "NewsBindingServerTask.h"
#import "NewsDownloadExpreesTask.h"
#import "SharedCoordinator.h"
#import "NewsDownloadTask.h"
#import "CheckUpdateTask.h"
#import "UserActions.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <QQConnection/QQConnection.h>
#import <RennSDK/RennSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import "WXApi.h"
#define KSQLFile @"news.sqlite"

@implementation XinHuaAppDelegate{
    NSTimer *connectionTimer;
    BOOL done;
}

@synthesize window = _window;
@synthesize startviewController=_startviewController,mainviewController=_mainviewController;
@synthesize db = _db;
@synthesize flag=_flag,isSuspended=_isSuspended;
@synthesize storeCoordinater=_storeCoordinater;
@synthesize objectConfigration=_objectConfigration;
- (void)initializePlat
{
    ///#begin zh-cn
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    ///#end
    ///#begin en
    /**
     Connect Sina Weibo applications to use these functions, this application requires SinaWeiboConnection.framework
     On http://open.weibo.com register application and related information to fill in the following fields
     **/
    ///#end
    [ShareSDK connectSinaWeiboWithAppKey:@"1192683311"
                               appSecret:@"b0e907b35eed0a817c83a6e035377643"
                             redirectUri:@"http://www.xinhuanet.com"];
    
    ///#begin zh-cn
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    ///#end
    ///#begin en
    /**
     Connect Tencent Weibo applications to use these functions, this application requires TencentWeiboConnection.framework
     On http://dev.t.qq.com register application and related information to fill in the following fields
     
     If you need to implement SSO, you need to import libWeiboSDK.a and the introduction of WBApi.h, WBApi types of incoming interfaces
     **/
    ///#end
    [ShareSDK connectTencentWeiboWithAppKey:@"801481570"
                                  appSecret:@"847ad3d675a0c9ced5e13fdef990640f"
                                redirectUri:@"http://www.xinhuanet.com"
                                   wbApiCls:[WeiboApi class]];
    
    ///#begin zh-cn
    //连接短信分享
    ///#end
    ///#begin en
    //Connect SMS
    ///#end
    [ShareSDK connectSMS];
    
    ///#begin zh-cn
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    ///#end
    ///#begin en
    /**
     Connect QZone applications to use these functions, this application requires QZoneConnection.framework
     On http://connect.qq.com/intro/login/ register application and related information to fill in the following fields
     
     If you need to implement SSO, you need to import TencentOpenAPI.framework and the introduction of QQApiInterface.h and TencentOAuth.h, QQApiInterface and TencentOAuth types of incoming interfaces
     **/
    ///#end
    [ShareSDK connectQZoneWithAppKey:@"101027087"
                           appSecret:@"03cb4268b00aa9e7af7318803e578e0e"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    ///#begin zh-cn
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    ///#end
    ///#begin en
    /**
     Connect WeChat applications to use these functions, this application requires WeChatConnection.framework and WeChat SDK
     On http://open.weixin.qq.com register application and related information to fill in the following fields
     **/
    ///#end
    [ShareSDK connectWeChatWithAppId:@"wx4f6447a0411918bd" wechatCls:[WXApi class]];
    
    ///#begin zh-cn
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    ///#end
    ///#begin en
    /**
     Connect QQ applications to use these functions, this application requires QQConnection.framework and QQApi.framework
     On http://mobile.qq.com/api/ register application and related information to fill in the following fields
     **/
    // Legacy appId in the application (eg: QQxxxxxx type), the following methods can be initialized
    ///#end
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"101027087"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    ///#begin zh-cn
    //连接邮件
    ///#end
    ///#begin en
    //Connect Mail
    ///#end
    [ShareSDK connectMail];
    

    
    ///#begin zh-cn
    //连接拷贝
    ///#end
    ///#begin en
    //Connect Copy
    ///#end
    [ShareSDK connectCopy];
}

///#begin zh-cn
/**
 *	@brief	托管模式下的初始化平台
 */
///#end
///#begin en
/**
 *	@brief	Hosted mode initialization platform
 */
///#end
- (void)initializePlatForTrusteeship
{
    ///#begin zh-cn
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    ///#end
    ///#begin en
    //Import QQ Connect classes, if not need share to QZone or QQ you can not call this method
    ///#end
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    
    ///#begin zh-cn
    //导入腾讯微博需要的外部库类型，如果不需要腾讯微博SSO可以不调用此方法
    ///#end
    ///#begin en
    //Import Tencent Weibo classes, if not need share to Tencent Weibo you can not call this method
    ///#end
    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    ///#begin zh-cn
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    ///#end
    ///#begin en
    //Import WeChat classes, if not need share to WeChat you can not call this method
    ///#end
    [ShareSDK importWeChatClass:[WXApi class]];
    
    
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (id)init
{
    self = [super init];
    if (self) {
       // _mainviewController = [[UINavigationController alloc] initWithRootViewController:[[XinHuaViewController alloc] init]];
        [self initSystem];
        NSLog(@"mainViewController in appdelegate %@",_objectConfigration.mainViewController);
        _mainviewController=[[UINavigationController alloc] initWithRootViewController:_objectConfigration.mainViewController];
        _startviewController=[[WelcomeViewController alloc] init];
        self.storeCoordinater=[[SharedCoordinator sharedInstance]persistentStoreCoordinator];
        NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: _storeCoordinater];
        self.db=[[NewsDbOperator alloc]initWithContext:managedObjectContext];
        [[NSUserDefaults  standardUserDefaults] setObject:@"20" forKey:@"SETDATE"];
        [[NSUserDefaults  standardUserDefaults] setObject:@"中" forKey:@"FONTSIZE"];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        //self.window.frame=CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height-20);
        NSLog(@"window y=%f h=%f",self.window.frame.origin.y,self.window.frame.size.height);
    }
    else {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    if (launchOptions) {           
        //截取apns推送的消息
        NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];   
        NSLog(@"pushInfo %@",pushInfo);
        //获取推送详情        
        self.window.rootViewController=_mainviewController;
        //self.window.backgroundColor=[UIColor whiteColor];
        [self.window makeKeyAndVisible];        
        ExpressNotificationViewController *aExpressController = [[ExpressNotificationViewController alloc] init];
        aExpressController.item_id=[pushInfo objectForKey:@"id"];
        [self.window.rootViewController presentViewController:aExpressController animated:YES completion:nil];
    }else{
        self.window.rootViewController=_startviewController;
        [self.window makeKeyAndVisible];
    }

    [self performSelectorInBackground:@selector(initShareSDK) withObject:nil];
    return YES;
}
-(void)clearlocalVersion{
    
}
-(void)initShareSDK{
    [ShareSDK registerApp:@"140e01391ea3"];
    [self initializePlat];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
#ifdef LNZW
        NSURL *requestURL =[NSURL URLWithString:@"http://mis.xinhuanet.com/lnzw/"];
#endif
#ifdef HNZW
        NSURL *requestURL =[NSURL URLWithString:@"http://mis.xinhuanet.com/hnzw/"];
#endif
        [[ UIApplication sharedApplication ] openURL:requestURL];
        NSLog(@"开始升级...");
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    self.isSuspended=YES;
    [[NewsUploadTokenTask sharedInstance] clearBadgeOnServer];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}
-(void)setLocalVersionInfo:(VersionInfo *)version_info{
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:version_info];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"version_info"];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"KVersionInfoOK" object: self userInfo:nil];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    [[NSNotificationCenter defaultCenter] postNotificationName: KEnterForeground
//                                                        object: self];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [[NewsUploadTokenTask sharedInstance] clearBadgeOnServer];
    [self postUserActions];
}
-(void)postUserActions{
    [[UserActions sharedInstance] reportActionsToServer];
}
-(void)initSystem{
    self.objectConfigration=[[ObjectConfigration alloc]init];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.isSuspended=NO;
    [self performSelectorInBackground:@selector(checkNewVersion) withObject:nil];
}
-(void)checkNewVersion{
    @try{
        if([[CheckUpdateTask sharedInstance] hasNewerVersion]){
            NSString *title=[NSString stringWithFormat:@"升级到 %@",[[CheckUpdateTask sharedInstance] newVersion]];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:[[CheckUpdateTask sharedInstance] getNewerVersionDescription] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }@catch(NSException *e){
        NSLog(@"版本升级功能失效！");
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
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
    {
        @autoreleasepool {
            [NSThread detachNewThreadSelector:@selector(downloadExpress:) toTarget:self withObject:[userInfo objectForKey:@"id"]];
        }
    }else{
        ExpressNotificationViewController *aController = [[ExpressNotificationViewController alloc] init];
        aController.item_id=[userInfo objectForKey:@"id"];
        self.window.rootViewController=_mainviewController;
        [self.window makeKeyAndVisible];
        [self.window.rootViewController presentViewController:aController animated:YES completion:nil];
    }
}
-(void)downloadExpress:(NSString *)item_id{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator=AppDelegate.storeCoordinater;
    NewsDbOperator *db=[[NewsDbOperator alloc]initWithContext:context];
    NewsDownloadTask *task=[[NewsDownloadTask alloc] initWithDB:db];
    [task GetdatafromWebToDb];
}
- (void)clearBadgeOnServer{
    NSString* regUrl = [NSString stringWithFormat:KClearBadgeURL,[UIDevice customUdid]];
    regUrl = [regUrl trimSpaceAndReturn];
    NSLog(@"reg = %@",regUrl);
    __weak ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setCompletionBlock:^{
        
        NSData*   responseData = [request responseData];
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
    }];
    [request setFailedBlock:^{
        NSLog(@"responseString = %@",[request.error localizedDescription]);
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
