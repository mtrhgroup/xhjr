//
//  RegisterViewController.m
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserDefaultManager.h"
#import "ASIHTTPRequest.h"
#import "NSIks.h"
#import "NewsDefine.h"
#import "Toast+UIView.h"
#import "NewsRegisterTask.h"
#import "NewsLocateView.h"
#import "NewsUserInfo.h"
#import "RegViewController.h"

#define kDuration 0.3
@interface RegisterViewController ()

@end
/*
 * notification : KShowToast           "显示后台任务的执行反馈"      userInfo:data  (NSString *) "执行反馈的文本信息"
 *                KBindleSnOK          "授权码注册成功"           
 */
@implementation RegisterViewController
@synthesize snInput;
@synthesize regBtn;
@synthesize collageBtn;
@synthesize waitingAlert;
NewsLocateView *collageSelector;
NewsUserInfo *user_info;
NSString *collageTitle;
NSString *collageCode;
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast:) name:KShowToast object:nil];        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindleSnOkHandler) name:KBindleSnOK object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUserInfo:) name:KUserInfoReady object:nil];
    }
    return self;
}
-(void)showToast:(NSNotification*) notification{
    [self.view hideToastActivity];
    NSString *info=[[notification userInfo] valueForKey:@"data"];
    [self.view makeToast:info
                duration:2.0
                position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]]; 
}
-(void)showUserInfo:(NSNotification *)notification{
    [self.view hideToastActivity];
    user_info=[(NewsUserInfo *)[[notification userInfo] objectForKey:@"data"] retain];
    NSLog(@"parser OK name%@",user_info.name);
    NSLog(@"parser OK sn%@",user_info.sn);
    NSLog(@"parser OK collage%@",user_info.company);
    NSLog(@"parser OK school%@",user_info.description);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户信息"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"确认", nil];
    alert.delegate=self;
    [alert show];
    [alert release];
}
-(void)bindleSnOkHandler{
    [self.view hideToastActivity];
    [self navigateToMainScene];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[UIApplication sharedApplication] unregisterForRemoteNotifications];
    self.navigationController.navigationBar.hidden = YES;
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];

    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"新华时讯通";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(returnclick:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [butb release];
    
    [self.view addSubview:bimgv];
    [bimgv release];
    
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"regsn_bg.png"]];
    
    UIImageView* uiv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10+44, 280, 224)];
   // [uiv setImage:[UIImage imageNamed:@"reg_gray.png"]];
    uiv.userInteractionEnabled =  YES;
    
    
    UILabel *tel_label1=[[UILabel alloc] initWithFrame:CGRectMake(40,20+44,240,40)];
    tel_label1.backgroundColor=[UIColor clearColor];
    tel_label1.textColor=[UIColor blackColor];
    //tel_label.text=@"联系电话：010－63077787";
    tel_label1.text=@"为了更好的为您提供服务，请输入您的联系方式。";
    tel_label1.numberOfLines=2;
    [self.view addSubview:tel_label1];
    [tel_label1 release];
    
    UILabel *tel_label=[[UILabel alloc] initWithFrame:CGRectMake(40,60+44,280,20)];
    tel_label.backgroundColor=[UIColor clearColor];
    tel_label.textColor=[UIColor blackColor];
    //tel_label.text=@"联系电话：010－63077787";
    tel_label.text=@"手机号：";
    [self.view addSubview:tel_label];
    [tel_label release];
    
    
    UITextField* tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 30+44, 240, 40)];
    tf.placeholder = @"";
    tf.background = [UIImage imageNamed:@"reg_input.png"];
    tf.textAlignment = UITextAlignmentCenter;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [tf becomeFirstResponder];
    self.snInput=tf;
    [uiv addSubview:tf];
    [tf release];
    UIButton *regbu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    regbu.frame = CGRectMake(20, 115, 110, 35);
    [regbu setTitle:@"登录" forState:UIControlStateNormal];
    //[regbu setBackgroundImage:[UIImage imageNamed:@"reg_reg.png"] forState:UIControlStateNormal];
    [regbu addTarget:self action:@selector(registger:) forControlEvents:UIControlEventTouchUpInside];
    [uiv addSubview:regbu];
    self.regBtn=regbu;
    [regbu release];
    
    UIButton *requestbu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    requestbu.frame = CGRectMake(150, 115, 110, 35);
    [requestbu setTitle:@"申请" forState:UIControlStateNormal];
    //[regbu setBackgroundImage:[UIImage imageNamed:@"reg_reg.png"] forState:UIControlStateNormal];
    [requestbu addTarget:self action:@selector(navigateToRegScene) forControlEvents:UIControlEventTouchUpInside];
    [uiv addSubview:requestbu];
//    [requestbu release];
  
    [self.view addSubview:uiv];
    [uiv release];}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    [collageSelector removeFromView];
    self.collageBtn.enabled=YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.collageBtn.enabled=YES;


    //You can uses location to your application.
    if(buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        NewsLocateView *locateView = (NewsLocateView *)actionSheet;
        collageTitle=locateView.collageTitle;
        collageCode=locateView.collageCode;
        NSLog(@"collage Name:%@ Code:%@", collageTitle, collageCode);
        [self.collageBtn setTitle:collageTitle forState:UIControlStateNormal];
    }
}

-(void)returnclick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)backAction:(id)sender{
    //[self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source
#pragma mark - Table view delegate
-(void)showCollagesView{
    [self.snInput resignFirstResponder];
    self.collageBtn.enabled=NO;
     collageSelector = [[NewsLocateView alloc] initWithFrame:CGRectMake(0,100, 320,260) delegate:self];
     [collageSelector showInView:self.view];
}
-(void)registger:(id)sender {

   // [self showUserInfo:nil];
    UITextField* field = (UITextField*)self.snInput;
    if([field.text isEqualToString:@""]||field.text==nil){
        [self.view makeToast:@"手机号不能为空！"
                    duration:1.0
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
        return;
    }
    NSString* authCode=field.text;;   

    [field resignFirstResponder];
    [self.view makeToastActivity:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
   [[NewsRegisterTask sharedInstance] execute:authCode];  
}

-(void)valueChanged:(id)sender {
    UITextField* textField = (UITextField*)sender;    
    UIButton* button = (UIButton*)self.regBtn;
    button.enabled = textField.text.length > 0;
    
}
-(void)navigateToRegScene{
    RegViewController *aViewController = [[[RegViewController alloc] init] autorelease];    
  [self.navigationController pushViewController:aViewController animated:YES];
}
-(void)navigateToMainScene{
    XinHuaViewController *mainController=[[[XinHuaViewController alloc] init] autorelease];
    UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:mainController];
    unc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:unc animated:YES];
    [unc release];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.snInput) {
        [theTextField resignFirstResponder];
    }
    return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [snInput release];
    [regBtn release];
    [waitingAlert release];
}
- (void)dealloc {
    [super dealloc];
}
@end
