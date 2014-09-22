//
//  WelcomeViewController.m
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WelcomeViewController.h"
#import "XinHuaViewController.h"
#import "Toast+UIView.h"
#import "NewsBindingServerTask.h"
#import "NewsDownloadImgTask.h"
#import "NewsDefine.h"
#import "RegisterViewController.h"
#import "VersionInfo.h"

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
- (void) viewDidLayoutSubviews {
    // only works for iOS 7+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        // snaps the view under the status bar (iOS 6 style)
        viewBounds.origin.y = topBarOffset*-1;
        
        // shrink the bounds of your view to compensate for the offset
        //viewBounds.size.height = viewBounds.size.height -20;
        self.view.bounds = viewBounds;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=true;
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,480+(iPhone5?88:0))];
    NSLog(@"iphone5 ?  %d",iPhone5);
    if(iPhone5){
    bg.image=[UIImage imageNamed:@"Default-568h@2x.png"];
    }else{
      bg.image=[UIImage imageNamed:@"Default@2x.png"];
    }
    [self.view addSubview:bg];
    NSString *imgPath=[self getLocalVersionInfo].startImgUrl;
    NSString* advPath = [CommonMethod fileWithDocumentsPath:@""];
    NSLog(@"%@",imgPath);
    NSLog(@"%@",advPath);
    imgPath=[imgPath stringByReplacingCharactersInRange:NSMakeRange(0, 72) withString:advPath];
    NSLog(@"%@",imgPath);
    [self addSubImgView:imgPath];
    if(![[NewsRegisterTask sharedInstance] isRegistered]){
       [NewsBindingServerTask execute];
    }else{
       [[NewsDownloadImgTask sharedInstance] execute];
       [self performSelector:@selector(navigateToMainScene) withObject:nil afterDelay:6.0];
    }

}
#if InHouseDistribution
-(void)bindlePhoneFailedHandler:(NSNotification*) notification{
    if([[NewsRegisterTask sharedInstance] isRegistered]){
        [self performSelector:@selector(navigateToMainScene) withObject:nil afterDelay:2.0];
    }else{
        [self performSelector:@selector(navigateToRegScene) withObject:nil afterDelay:2.0];
    }
    
}
-(void)bindlePhoneOkHandler:(NSNotification*) notification{
    NSString *usertype=[[notification userInfo] valueForKey:@"data"];
    [[NewsDownloadImgTask sharedInstance] execute];
    if([usertype isEqualToString:@"old"]){
        if([[NewsRegisterTask sharedInstance] isRegistered]){
            [self performSelector:@selector(navigateToMainScene) withObject:nil afterDelay:2.0];
        }else{
            [self performSelector:@selector(navigateToRegScene) withObject:nil afterDelay:2.0];
        }
        
    }else{
        [self performSelector:@selector(navigateToRegScene) withObject:nil afterDelay:2.0];
    }
}
#else
-(void)bindlePhoneFailedHandler:(NSNotification*) notification{
    NSLog(@"failed");
    [self performSelector:@selector(navigateToMainScene) withObject:nil afterDelay:2.0];
}
-(void)bindlePhoneOkHandler:(NSNotification*) notification{
    NSLog(@"OK");
    [self navigateToMainScene];
}
#endif 
-(void)pictureReadyHandler:(NSNotification*) notification{
    NSLog(@"pictureReadyHandler");
     NSString *filepath=[[notification userInfo] valueForKey:@"data"];
    [self addSubImgView:filepath];
}
-(void)navigateToRegScene{
    RegisterViewController* rvc = [[RegisterViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:rvc];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)navigateToMainScene{
    AppDelegate.mainviewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentViewController: AppDelegate.mainviewController animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EnterSystemNotifiction object:nil];
}
NSString *EnterSystemNotifiction=@"EnterSystemNotifiction";
#ifdef LNZW
-(void)addSubImgView:(NSString *)pathImg{
    NSLog(@"addSubImgView %@",pathImg);
    if(pathImg==nil)return;
    UIImageView *subImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 410+(iPhone5?88:0))];
    self.subImg = subImage;
    self.subImg.image= [[UIImage alloc] initWithContentsOfFile:pathImg];

    UIImage *advImg=[[UIImage alloc] initWithContentsOfFile:pathImg];
    advImg=[advImg scaleToSize:CGSizeMake(320, 410+(iPhone5?88:0))];
    UIButton *advBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 410+(iPhone5?88:0))];
    [advBtn setBackgroundColor:[UIColor colorWithPatternImage:advImg]];
    [advBtn addTarget:self action:@selector(showArticle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:advBtn];
}
#endif
#ifdef HNZW
-(void)addSubImgView:(NSString *)pathImg{
    NSLog(@"addSubImgView %@",pathImg);
    if(pathImg==nil)return;
    UIImageView *subImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 410+(iPhone5?88:0))];
    self.subImg = subImage;
    self.subImg.image= [[UIImage alloc] initWithContentsOfFile:pathImg];
    UIImage *advImg=[[UIImage alloc] initWithContentsOfFile:pathImg];
    float preferHight=advImg.size.height;
    float preferWidth=advImg.size.width;
    float preferX=0;
    float preferY=0;
    if(advImg.size.width>320){
    preferHight=(advImg.size.height*320)/advImg.size.width;
    if(preferHight>410+(iPhone5?88:0)){
        preferWidth=(advImg.size.width*(410+(iPhone5?88:0)))/advImg.size.height;
        preferHight=410+(iPhone5?88:0);
    }else{
        preferWidth=320;
    }
    }
    if(preferHight>410+(iPhone5?88:0)){
        preferWidth=(advImg.size.width*(410+(iPhone5?88:0)))/advImg.size.height;
        preferHight=410+(iPhone5?88:0);
    }
    NSLog(@"%f %f %f",preferHight,advImg.size.width,advImg.size.height);
    advImg=[advImg scaleToSize:CGSizeMake(preferWidth, preferHight)];

    if(preferWidth<320){
        preferX=(320-preferWidth)/2;
    }else{
        preferX=0;
    }
 preferY=0;
    NSLog(@"x=%f w=%f h=%f",preferX,preferWidth,preferHight);
    UIButton *advBtn=[[UIButton alloc] initWithFrame:CGRectMake(preferX, preferY, preferWidth, preferHight)];
    [advBtn setBackgroundColor:[UIColor colorWithPatternImage:advImg]];
    [advBtn addTarget:self action:@selector(showArticle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:advBtn];
}
#endif
-(void)showArticle:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowAdvPageNotification object:nil];
}
-(VersionInfo *)getLocalVersionInfo{
    NSData *old_data=[[NSUserDefaults standardUserDefaults]objectForKey:@"version_info"];
    VersionInfo *version_info_local=[NSKeyedUnarchiver unarchiveObjectWithData:old_data];
    return version_info_local;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return false;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
NSString *ShowAdvPageNotification=@"ShowAdvPageNotification";
@end
