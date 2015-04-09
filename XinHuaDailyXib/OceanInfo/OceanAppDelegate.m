//
//  DFNAppDelegate.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//
#import "OceanAppDelegate.h"
#import "NavigationController.h"
#import "LeftViewController.h"
#import <Frontia/FrontiaPush.h>
#import <Frontia/Frontia.h>
#import "Cryptor.h"
@implementation OceanAppDelegate
@synthesize service=_service;
@synthesize channel=_channel;
@synthesize share=_share;
@synthesize main_vc=_main_vc;
@synthesize reg_vc=_reg_vc;
@synthesize prepare_error_alert=_prepare_error_alert;
@synthesize push_article_alert=_push_article_alert;
@synthesize user_defaults=_user_defaults;
@synthesize is_full=_is_full;
#define DeviceTokenRegisteredKEY @"DeviceTokenStringKEY"
#define DeviceTokenStringKEY @"DeviceTokenStringKEY"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Frontia initWithApiKey:APP_KEY];
    [Frontia getPush];
    [FrontiaPush setupChannel:launchOptions];
    [self setupApp];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self.user_defaults.is_authorized){
         AppDelegate.channel=[self.service fetchMRCJChannelFromDB];
        [self.window setRootViewController:self.main_vc];
        [self.window makeKeyAndVisible];
    }else{
        NavigationController *nav_vc=[[NavigationController alloc] initWithRootViewController:self.reg_vc];
        [self.window setRootViewController:nav_vc];
        [self.window makeKeyAndVisible];
    }
    if (launchOptions) {
        //截取apns推送的消息
        NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        [self.main_vc presentArticleContentVCWithPushArticleID:[pushInfo valueForKey:@"id"]];
    }
    [self performSelectorInBackground:@selector(initBaiduFrontia) withObject:nil];
    [_service checkVersion:^(BOOL isOK) {
        //<#code#>
    } errorHandler:^(NSError *error) {
        //<#code#>
    }];
    
    return YES;
}
-(void)setupApp{
    self.service=[[Service alloc] init];
    self.user_defaults=[[UserDefaults alloc] init];
    self.main_vc=[[DrawerViewController alloc] init];
    self.reg_vc=[[RegisterViewController alloc] init];
    self.prepare_error_alert=[[UIAlertView alloc] initWithTitle:@"系统初始化失败"  message:@"请联网后重试！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    Cryptor *cryptor=[[Cryptor alloc] init];
    NSString *plain_text=@"/mif/Common/common_GetLiterMemo.ashx?n=20&appid=XHJR&time=20501231235959&imei=XHJR_358834047516299&timetype=-1&sn=XHJR_18210972003&type=prevue";
    NSString *aes_key=@"zhangjian";
    
    NSString *cipher_text=[cryptor AES256_Encrypt:plain_text withKey:aes_key];
    NSString *decrypt_text=[cryptor AES256_Decrypt:cipher_text withKey:aes_key];
    NSString *md5_text=[cryptor md5:aes_key];
    NSLog(@"\n md5 :%@",md5_text);
    NSLog(@"\n plain_text: %@\n cipher_text: %@\n decrypt_text: %@\n",plain_text,cipher_text,decrypt_text);
    //encrypt
//    NSString *cipher_text_rsa = [cryptor RSA_EncryptUsingPublicKeyWithData:plain_text];
//    //decrypt
//    NSLog(@"\n cipher_text_rsa : %@ \n ",cipher_text_rsa);
}

-(void)initBaiduFrontia{
    self.share=[Frontia getShare];
    [self.share registerQQAppId:@"100358052" enableSSO:NO];
    [self.share registerWeixinAppId:@"wx712df8473f2a1dbe"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[UIScreen mainScreen] setBrightness:self.user_defaults.outside_brightness_value];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.user_defaults.outside_brightness_value=[[UIScreen mainScreen] brightness];
    if(self.user_defaults.is_night_mode_on){
        [UIScreen mainScreen].brightness=0.1;
    }
}

//向服务器申请发送token 判断事前有没有发送过
- (void)registerForRemoteNotificationToGetToken
{
    NSLog(@"Registering for push notifications...");
    
    //注册Device Token, 需要注册remote notification
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if (![userDefaults boolForKey:DeviceTokenRegisteredKEY])   //如果没有注册到令牌 则重新发送注册请求
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeNewsstandContentAvailability |
              UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
              UIRemoteNotificationTypeSound)];
        });
    }
    
    //将远程通知的数量置零
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        //1 hide the local badge
        if ([[UIApplication sharedApplication] applicationIconBadgeNumber] == 0) {
            return;
        }
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        //2 ask the provider to set the BadgeNumber to zero
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *deviceTokenStr = [userDefaults objectForKey:DeviceTokenStringKEY];
        [self resetBadgeNumberOnProviderWithDeviceToken:deviceTokenStr];
    });
    
}
- (void)resetBadgeNumberOnProviderWithDeviceToken: (NSString *)deviceTokenString
{
    NSLog(@"  reset Provider DeviceToken %@", deviceTokenString);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"frontia application:%@", deviceToken);
    
    
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
Article *push_article;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if([UIApplication sharedApplication].applicationState==UIApplicationStateInactive){
        [self.main_vc presentArticleContentVCWithPushArticleID:[userInfo valueForKey:@"id"]];
    }else{
        [_service fetchOneArticleWithArticleID:[userInfo valueForKey:@"id"] successHandler:^(Article *article) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:article.article_title  message:article.summary delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"点击阅读", nil];
            
            [alertView show];
        } errorHandler:^(NSError *error) {
            //<#code#>
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if(self.is_full)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
}

@end
