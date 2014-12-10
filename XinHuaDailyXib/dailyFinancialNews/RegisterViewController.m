//
//  RegisterViewController.m
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "NavigationController.h"
#import "VerifyCodeSubmitViewController.h"
#import "AMBlurView.h"
#import "GlobalVariablesDefine.h"
#import "UIButton+Bootstrap.h"
#define kDuration 0.3
@interface RegisterViewController ()
@property (nonatomic,strong) AMBlurView *blurView;
@property(nonatomic,strong)Service *service;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIAlertView *confirm_phone_number_alert;
@end

@implementation RegisterViewController{
    UIButton *verify_get_btn;
}
@synthesize phone_number_input=_phone_number_input;
@synthesize verify_code_input=_verify_code_input;
@synthesize regBtn;
@synthesize waitingAlert;
@synthesize service=_service;
@synthesize timer=_timer;
@synthesize confirm_phone_number_alert=_confirm_phone_number_alert;

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
    self.title=@"账号绑定";
    self.view.backgroundColor=VC_BG_COLOR;
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(10.f, (lessiOS7)?20:20+44, 300, 60)];
    [self.blurView.layer setMasksToBounds:YES];
    [self.blurView.layer setCornerRadius:10];
    [self.view addSubview:[self blurView]];
    
    _phone_number_input = [[UITextField alloc] initWithFrame:CGRectMake(20, (lessiOS7)?30:30+44, 180, 40)];
    _phone_number_input.placeholder = @" 请输入手机号码";
    _phone_number_input.backgroundColor=[UIColor clearColor];
    _phone_number_input.layer.cornerRadius = 10.0f;
    _phone_number_input.textAlignment = NSTextAlignmentLeft;
    _phone_number_input.keyboardType=UIKeyboardTypePhonePad;
    _phone_number_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_phone_number_input becomeFirstResponder];
    _phone_number_input.layer.borderWidth = 1.0f;
    _phone_number_input.layer.borderColor = [[UIColor grayColor] CGColor];
    [_phone_number_input addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phone_number_input];
    verify_get_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    verify_get_btn.frame = CGRectMake(210, (lessiOS7)?30:30+44, 90, 40);
    [verify_get_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    verify_get_btn.backgroundColor=[UIColor whiteColor];
    [verify_get_btn.layer setMasksToBounds:YES];
    [verify_get_btn.layer setCornerRadius:10.0];
    [verify_get_btn.layer setBorderWidth:0.2];
    verify_get_btn.tintColor=[UIColor blackColor];
    verify_get_btn.enabled=NO;
    [verify_get_btn addTarget:self action:@selector(verifyGetBtnClickHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verify_get_btn];
    UILabel *tip=[[UILabel alloc] initWithFrame:CGRectMake(self.blurView.frame.origin.x, self.blurView.frame.origin.y+self.blurView.frame.size.height+10, self.blurView.frame.size.width, 40)];
    tip.text=@"订购热线：8868585转8";
    tip.backgroundColor=[UIColor clearColor];
    tip.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tip];
    if(self.inside){
        [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)verifyGetBtnClickHandler{ 
    self.confirm_phone_number_alert=[[UIAlertView alloc] initWithTitle:@"确认手机号码"  message:[NSString stringWithFormat:@"我们将发送验证码短信到这个号码：%@",_phone_number_input.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
    [self.confirm_phone_number_alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self requestVerifyCode];
    }
}
-(void)back{
    [_phone_number_input resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

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
        VerifyCodeSubmitViewController *controller=[[VerifyCodeSubmitViewController alloc]init];
        controller.service=self.service;
        controller.phone_number=self.phone_number_input.text;
        controller.inside=self.inside;
        [self.navigationController pushViewController:controller animated:YES];
    } errorHandler:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
       [self.view.window showHUDWithText:error.localizedDescription Type:ShowPhotoNo Enabled:YES];
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    if (theTextField == self.snInput) {
//        [theTextField resignFirstResponder];
//    }
   return YES;
}
-(void)textFieldDidChange:(UITextField *)textField{
    if(_phone_number_input.text.length==11){
        verify_get_btn.enabled=YES;
    }else{
        verify_get_btn.enabled=NO;
    }
}

@end
