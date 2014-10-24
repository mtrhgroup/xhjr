//
//  ContactUsViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContactUsViewController.h"
#import "UIPlaceHolderTextView.h"
#import "ASIFormDataRequest.h"
#import "UIWindow+YzdHUD.h"
#import "NavigationController.h"
#import "AMBlurView.h"
@interface ContactUsViewController ()
@property (nonatomic,strong) AMBlurView *blurView;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast:) name:kNotificationMessage object:nil];
    }
    return self;
}

-(void)showToast:(NSNotification*) notification{
    NSString *info=[[notification userInfo] valueForKey:@"data"];
   [self.view.window showHUDWithText:info Type:ShowLoading Enabled:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"反馈意见";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"regsn_bg.png"]];
    
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(10.f, 40+44, 300, 170)];
    [self.blurView.layer setMasksToBounds:YES];
    [self.blurView.layer setCornerRadius:10];
    //[self.blurView setAlpha:0.6];
    [[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:[self blurView]];
    
    UIPlaceHolderTextView* content = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 50+44, 280, 100)];
   // content.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    content.layer.cornerRadius = 10.0f;
    [content setFont:[UIFont systemFontOfSize:17 ]];
    content.layer.borderWidth = 1.0f;
    content.layer.borderColor = [[UIColor grayColor] CGColor];
    content.placeholder = @"请输入反馈，我们将为您不断改进";
    content.placeholderColor=[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
    content.contentInset = UIEdgeInsetsMake(2,2,2,2);
    content.backgroundColor=[UIColor clearColor];
    self.contentTV=content;
    [self.view addSubview:content];
    NSString *lastEmail=[[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
    UITextField* email = [[UITextField alloc] initWithFrame:CGRectMake(20, 160+44, 280, 40)];
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
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"forward.png"] target:self action:@selector(send_Message) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.view.window showHUDWithText:@"" Type:ShowLoading Enabled:YES];
    NSString* authcode = [[NSUserDefaults standardUserDefaults] valueForKey:KUserDefaultAuthCode];
    [[NSUserDefaults  standardUserDefaults] setValue:emailStr forKey:@"email"];
    //[[NewsFeedBackTask sharedInstance] execute:authcode emailStr:emailStr contentStr:contentStr];
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
