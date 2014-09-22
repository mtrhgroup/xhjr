//
//  ContactUsViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContactUsViewController.h"
#import "Toast+UIView.h"
#import "UIPlaceHolderTextView.h"
#import "ASIFormDataRequest.h"
#import "NewsFeedBackTask.h"
@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

@synthesize contentTV;
@synthesize emailTF;
@synthesize waitingAlert;
@synthesize mode;
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast:) name:KShowToast object:nil]; 
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
-(void)showToast:(NSNotification*) notification{
   [self.view hideToastActivity];
   NSString *info=[[notification userInfo] valueForKey:@"data"];
    [self.view makeToast:info
                duration:2.0
                position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"ext_navbar.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(returnclick:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"意见反馈";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    [bimgv addSubview:lab];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 8, 43,29)];     
    UIImage * send_image=[UIImage imageNamed:@"send.png"];
    [sendBtn setImage:send_image forState:UIControlStateNormal];
    [sendBtn  addTarget:self action:@selector(send_Message) forControlEvents:UIControlEventTouchUpInside];
    [bimgv addSubview:sendBtn];
    
    [self.view addSubview:bimgv];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about_bac.png"]];

    
    UIPlaceHolderTextView* content = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 50, 280, 100)];
   // content.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    content.layer.cornerRadius = 10.0f;
    [content setFont:[UIFont systemFontOfSize:17 ]];
    content.layer.borderWidth = 1.0f;
    content.layer.borderColor = [[UIColor grayColor] CGColor];
    content.placeholder = @"请输入反馈，我们将为您不断改进";
    content.placeholderColor=[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
    content.contentInset = UIEdgeInsetsMake(2,2,2,2);
    self.contentTV=content;
    [self.view addSubview:content];
    NSString *lastEmail=[[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
    UITextField* email = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, 280, 40)];
    email.layer.borderWidth = 1.0f;
    email.layer.borderColor = [[UIColor grayColor] CGColor];
    UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
    email.layer.cornerRadius = 10.0f;
    paddingView.text = @"  您的邮箱:";
    paddingView.textColor = [UIColor blackColor];
    paddingView.backgroundColor = [UIColor clearColor];
    email.leftView = paddingView;
    email.leftViewMode = UITextFieldViewModeAlways;
    email.placeholder = @"便于我们给您反馈";
    email.textAlignment = NSTextAlignmentLeft;
    email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if(lastEmail!=nil){
       email.text=lastEmail;
    }
    self.emailTF=email;
    [self.view addSubview:email];
    
    [self.contentTV becomeFirstResponder];
    
    [self makeWaitingAlert];
	// Do any additional setup after loading the view.
}
-(void)makeWaitingAlert{
    self.waitingAlert = [[UIAlertView alloc]initWithTitle:@"请等待" 
                                                   message:nil                         
                                                  delegate:nil   
                                         cancelButtonTitle:nil                     
                                         otherButtonTitles:nil];  
    
}
-(void)showWaitingAlert{
    [self.waitingAlert show];
    UIActivityIndicatorView*activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];    
    activeView.center = CGPointMake(waitingAlert.bounds.size.width/2.0f, waitingAlert.bounds.size.height-40.0f);      
    [activeView startAnimating];      
    [waitingAlert addSubview:activeView];         
}
-(void)hideWaitingAlert{
    [self.waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}
-(void)returnclick:(id)sender{
    if(mode==1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}
-(void)send_Message{
    NSString *contentStr=self.contentTV.text;
    NSString *emailStr=self.emailTF.text;
    if(contentStr==nil||[contentStr isEqualToString:@""]){
        [self showAlertText:@"请输入内容"];
        return;
    }
    if(emailStr==nil||[emailStr isEqualToString:@""]){
        [self showAlertText:@"请输入您的邮箱地址"];
        return;
    }
    if(![self validateEmailWithString:emailStr]){
        [self showAlertText:@"请输入有效邮箱地址"];
        return;
    }
    [self.view makeToastActivity:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
    NSString* authcode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode];
    [[NSUserDefaults  standardUserDefaults] setValue:emailStr forKey:@"email"];
    [[NewsFeedBackTask sharedInstance] execute:authcode emailStr:emailStr contentStr:contentStr];    
}
- (void)showAlertText:(NSString*)string
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alert show];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
