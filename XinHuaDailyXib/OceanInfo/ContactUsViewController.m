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
#import "GlobalVariablesDefine.h"
#import "UIButton+Bootstrap.h"
@interface ContactUsViewController ()
@property (nonatomic,strong)AMBlurView *blurView;
@property(nonatomic,strong)Service *service;
@end

@implementation ContactUsViewController{
    UIButton *send_btn;
    UITextField* email;
}


@synthesize contentTV;
@synthesize emailTF;
@synthesize waitingAlert;
@synthesize mode;
@synthesize service;
- (id)init
{
    self = [super init];
    if (self) {
        self.service=AppDelegate.service;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"写反馈";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_waterwave.png"]]];
    
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(10.f, (lessiOS7)?20:20, self.view.bounds.size.width-20, 170)];
    [self.blurView.layer setMasksToBounds:YES];
    [self.blurView.layer setCornerRadius:10];
    [self.view addSubview:[self blurView]];
    
    UIPlaceHolderTextView* content = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, self.blurView.bounds.size.width-20, 100)];
    // content.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    content.layer.cornerRadius = 10.0f;
    [content setFont:[UIFont systemFontOfSize:17 ]];
    content.layer.borderWidth = 1.0f;
    content.layer.borderColor = [[UIColor grayColor] CGColor];
    content.placeholder = @"请输入反馈，我们将为您不断改进!";
    content.placeholderColor=[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
    content.contentInset = UIEdgeInsetsMake(2,2,2,2);
    content.backgroundColor=[UIColor clearColor];
    self.contentTV=content;
    [self.blurView addSubview:content];
    NSString *lastEmail=[[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
    email = [[UITextField alloc] initWithFrame:CGRectMake(10, 120, self.blurView.bounds.size.width-20, 40)];
    email.layer.borderWidth = 1.0f;
    email.layer.borderColor = [[UIColor grayColor] CGColor];
    UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
    email.layer.cornerRadius = 10.0f;
    paddingView.text = @"  您的邮箱:";
    paddingView.textColor = [UIColor blackColor];
    paddingView.backgroundColor = [UIColor clearColor];
    email.leftView = paddingView;
    email.leftViewMode = UITextFieldViewModeAlways;
    email.placeholder = @"便于我们联系";
    email.textAlignment = NSTextAlignmentLeft;
    email.delegate=self;
    email.returnKeyType = UIReturnKeyDone;
    email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if(lastEmail!=nil){
        email.text=lastEmail;
    }
    self.emailTF=email;
    [self.blurView addSubview:email];
    send_btn=[[UIButton alloc] initWithFrame:CGRectMake(10, self.blurView.frame.origin.y+self.blurView.frame.size.height+5, self.blurView.frame.size.width, 40)];
    [send_btn primaryStyle];
    [send_btn setTitle:@"发送" forState:UIControlStateNormal];
    [send_btn addTarget:self action:@selector(send_Message) forControlEvents:UIControlEventTouchUpInside];
    send_btn.enabled=NO;
    [self.view addSubview:send_btn];
    [self.contentTV becomeFirstResponder];
    
    [self makeWaitingAlert];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)back{
    [contentTV resignFirstResponder];
    [email resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
- (BOOL)validateEmailWithString:(NSString*)email_content
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email_content];
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
    [self.service feedbackAppWithContent:contentStr email:emailStr successHandler:^(BOOL is_ok) {
        [self.view.window showHUDWithText:@"发送成功" Type:ShowPhotoYes Enabled:YES];
    } errorHandler:^(NSError *error) {
        [self.view.window showHUDWithText:error.localizedDescription Type:ShowPhotoNo Enabled:YES];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        self.view.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
//        
//    }completion:nil];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:email]) {
        
//        [UIView animateWithDuration:0.25 animations:^{
//            
//            self.view.frame = CGRectMake(0.f, -10.f, self.view.frame.size.width, self.view.frame.size.height);
//            
//        }completion:nil] ;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *contentStr=self.contentTV.text;
    NSString *emailStr=self.emailTF.text;
    if(contentStr==nil||[contentStr isEqualToString:@""]){
        [self showAlertText:@"请输入内容"];
        send_btn.enabled=NO;
        return;
    }
    if(emailStr==nil||[emailStr isEqualToString:@""]){
        [self showAlertText:@"请输入您的邮箱地址"];
        send_btn.enabled=NO;
        return;
    }
    if(![self validateEmailWithString:emailStr]){
        [self showAlertText:@"请输入有效邮箱地址"];
        send_btn.enabled=NO;
        return;
    }
    send_btn.enabled=YES;
    
}
- (void)showAlertText:(NSString*)string
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alert show];
}
/**
 *	@brief	键盘出现
 *
 *	@param 	aNotification 	参数
 */
- (void)keyboardWillShow:(NSNotification *)aNotification

{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, -10.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil] ;
    
}

/**
 *	@brief	键盘消失
 *
 *	@param 	aNotification 	参数
 */
- (void)keyboardWillHide:(NSNotification *)aNotification

{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil];
    
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
