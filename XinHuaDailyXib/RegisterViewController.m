//
//  RegisterViewController.m
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "NavigationController.h"
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

NSString *collageTitle;
NSString *collageCode;
- (id)init
{
    self = [super init];
    if (self) {

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
    UITextField* phone_number_input = [[UITextField alloc] initWithFrame:CGRectMake(20, 30+44, 180, 40)];
    phone_number_input.placeholder = @" 输入手机号码";
    phone_number_input.background = [UIImage imageNamed:@"reg_input.png"];
    phone_number_input.textAlignment = NSTextAlignmentLeft;
    phone_number_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [phone_number_input becomeFirstResponder];
    self.snInput=phone_number_input;
    [self.view addSubview:phone_number_input];
    UIButton *verify_get_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    verify_get_btn.frame = CGRectMake(210, 30+44, 90, 40);
    [verify_get_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    verify_get_btn.backgroundColor=[UIColor whiteColor];
    [verify_get_btn.layer setMasksToBounds:YES];
    [verify_get_btn.layer setCornerRadius:10.0];
    [verify_get_btn.layer setBorderWidth:0.2];
    verify_get_btn.tintColor=[UIColor blackColor];
    [verify_get_btn addTarget:self action:@selector(registger:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verify_get_btn];
    
    UITextField* tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 80+44, 180, 40)];
    tf.placeholder = @" 输入验证码";
    tf.background = [UIImage imageNamed:@"reg_input.png"];
    tf.textAlignment = NSTextAlignmentLeft;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [tf becomeFirstResponder];
    self.snInput=tf;
    [self.view addSubview:tf];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"cloudcheck.png"] target:self action:@selector(bindSN) forControlEvents:UIControlEventTouchUpInside];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)bindSN{
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.collageBtn.enabled=YES;
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

-(void)registger:(id)sender {

   // [self showUserInfo:nil];
    UITextField* field = (UITextField*)self.snInput;
    if([field.text isEqualToString:@""]||field.text==nil){
//        [self.view makeToast:@"序列号不能为空！"
//                    duration:1.0
//                    position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
        return;
    }
    NSString* authCode=field.text;;   

    [field resignFirstResponder];

}

-(void)valueChanged:(id)sender {
    UITextField* textField = (UITextField*)sender;    
    UIButton* button = (UIButton*)self.regBtn;
    button.enabled = textField.text.length > 0;
    
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
}

@end
