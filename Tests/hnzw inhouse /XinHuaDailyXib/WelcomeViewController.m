//
//  WelcomeViewController.m
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WelcomeViewController.h"
#import "XinHuaViewController.h"
#import "UserDefaultManager.h"
#import "Toast+UIView.h"
#import "NewsBindingServerTask.h"
#import "NewsDownloadImgTask.h"
#import "NewsDefine.h"
#import "RegisterViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController
@synthesize subImg;
@synthesize mainViewController;
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindlePhoneOkHandler:) name:KBindlePhoneOK object:nil];  
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindlePhoneFailedHandler:) name:KBindlePhoneFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pictureReadyHandler:) name:KPictureOK object:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=true;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,480+(iPhone5?88:0))];
    NSLog(@"iphone5 ?  %d",iPhone5);
    bg.image=[UIImage imageNamed:@"Default.png"];
    [self.view addSubview:bg];
    [NewsBindingServerTask execute];
//    self.mainViewController=[[UINavigationController alloc] initWithRootViewController:[[XinHuaViewController alloc]init]];
    [NewsDownloadImgTask execute];
}

-(void)bindlePhoneFailedHandler:(NSNotification*) notification{
    NSLog(@"failed");
    [self performSelector:@selector(navigateToMainScene) withObject:nil afterDelay:2.0];
}
-(void)bindlePhoneOkHandler:(NSNotification*) notification{
    NSLog(@"OK");
    [self navigateToMainScene];
}
-(void)pictureReadyHandler:(NSNotification*) notification{
    NSLog(@"pictureReadyHandler");
     NSString *filepath=[[notification userInfo] valueForKey:@"data"];
    [self addSubImgView:filepath];
}
-(void)navigateToRegScene{
    RegisterViewController* rvc = [[RegisterViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:rvc];
    [self presentModalViewController:nav animated:YES];
    [rvc release];
    [nav release];
}
-(void)navigateToMainScene{
    AppDelegate.mainviewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController: AppDelegate.mainviewController animated:YES];
}

-(void)addSubImgView:(NSString *)pathImg{
    NSLog(@"addSubImgView %@",pathImg);
    UIImageView *subImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480+(iPhone5?88:0))];
    self.subImg = subImage;
    [subImage release];
    self.subImg.image= [[UIImage alloc] initWithContentsOfFile:pathImg];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	animation.type = kCATransitionFade;
	animation.subtype = kCATransitionReveal;	
	[self.view.layer addAnimation:animation forKey:@"animation"];
    [self.view addSubview:self.subImg];
    [UIView commitAnimations];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return false;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [subImg release];
    [mainViewController release];
}

@end
