//
//  RegisterViewController.m
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "NavigationController.h"
#import "AMBlurView.h"
#define kDuration 0.3
@interface RegisterViewController ()
@property (nonatomic,strong) AMBlurView *blurView;
@property(nonatomic,strong)Service *service;
@end
/*
 * notification : KShowToast           "显示后台任务的执行反馈"      userInfo:data  (NSString *) "执行反馈的文本信息"
 *                KBindleSnOK          "授权码注册成功"           
 */
@implementation RegisterViewController
@synthesize phone_number_input=_phone_number_input;
@synthesize verify_code_input=_verify_code_input;
@synthesize regBtn;
@synthesize waitingAlert;
@synthesize service=_service;

- (id)init
{
    self = [super init];
    if (self) {
        self.service=AppDelegate.service;
    }
    return self;
}


-(void)bindleSnOkHandler{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"用户认证";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"regsn_bg.png"]];
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(10.f, 40+44, 300, 110)];
    [self.blurView.layer setMasksToBounds:YES];
    [self.blurView.layer setCornerRadius:10];
    //[self.blurView setAlpha:0.6];
    [[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:[self blurView]];
    
    _phone_number_input = [[UITextField alloc] initWithFrame:CGRectMake(20, 50+44, 180, 40)];
    _phone_number_input.placeholder = @" 输入手机号码";
    _phone_number_input.backgroundColor=[UIColor clearColor];
    _phone_number_input.layer.cornerRadius = 10.0f;
    _phone_number_input.textAlignment = NSTextAlignmentLeft;
    _phone_number_input.keyboardType=UIKeyboardTypePhonePad;
    _phone_number_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_phone_number_input becomeFirstResponder];
    _phone_number_input.layer.borderWidth = 1.0f;
    _phone_number_input.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:_phone_number_input];
    UIButton *verify_get_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    verify_get_btn.frame = CGRectMake(210, 50+44, 90, 40);
    [verify_get_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    verify_get_btn.backgroundColor=[UIColor whiteColor];
    [verify_get_btn.layer setMasksToBounds:YES];
    [verify_get_btn.layer setCornerRadius:10.0];
    [verify_get_btn.layer setBorderWidth:0.2];
    verify_get_btn.tintColor=[UIColor blackColor];
    [verify_get_btn addTarget:self action:@selector(requestVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verify_get_btn];
    
    _verify_code_input = [[UITextField alloc] initWithFrame:CGRectMake(20, 100+44, 280, 40)];
    _verify_code_input.placeholder = @" 输入验证码";
    _verify_code_input.backgroundColor=[UIColor clearColor];
    _verify_code_input.textAlignment = NSTextAlignmentLeft;
    _verify_code_input.layer.cornerRadius = 10.0f;
    _verify_code_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_verify_code_input becomeFirstResponder];
    _verify_code_input.layer.borderWidth = 1.0f;
    _verify_code_input.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:_verify_code_input];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"cloudcheck.png"] target:self action:@selector(bindPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(void)returnclick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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


-(void)requestVerifyCode{
    [self.service requestVerifyCodeWithPhoneNumber:_phone_number_input.text successHandler:^(BOOL is_ok) {
       // <#code#>
    } errorHandler:^(NSError *error) {
       // <#code#>
    }];
}

-(void)bindPhoneNumber{
    [self.service registerPhoneNumberWithPhoneNumber:_phone_number_input.text verifyCode:_verify_code_input.text successHandler:^(BOOL is_ok) {
        //<#code#>
    } errorHandler:^(NSError *error) {
       // <#code#>
    }];
}
-(void)valueChanged:(id)sender {
//    UITextField* textField = (UITextField*)sender;    
//    UIButton* button = (UIButton*)self.regBtn;
//    button.enabled = textField.text.length > 0;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    if (theTextField == self.snInput) {
//        [theTextField resignFirstResponder];
//    }
   return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
