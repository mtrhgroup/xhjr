//
//  VerifyCodeSubmitViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14/10/25.
//
//

#import "VerifyCodeSubmitViewController.h"
#import "NavigationController.h"
#import "AMBlurView.h"
#import "GlobalVariablesDefine.h"
#import "UIButton+Bootstrap.h"
@interface VerifyCodeSubmitViewController ()
@property (nonatomic,strong) AMBlurView *blurView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIAlertView *confirm_back_alert;
@end
@implementation VerifyCodeSubmitViewController{
    UIButton *send_btn;
}
@synthesize verify_code_input=_verify_code_input;
@synthesize phone_number=_phone_number;
@synthesize service=_service;
@synthesize confirm_back_alert=_confirm_back_alert;

- (void)viewDidLoad
{
    self.title=@"填写验证码";
    self.view.backgroundColor=VC_BG_COLOR;
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(10.f, (lessiOS7)?20:20+44, 300, 60)];
    [self.blurView.layer setMasksToBounds:YES];
    [self.blurView.layer setCornerRadius:10];
    [self.view addSubview:[self blurView]];
    _verify_code_input = [[UITextField alloc] initWithFrame:CGRectMake(20, (lessiOS7)?30:30+44, 280, 40)];
    _verify_code_input.placeholder = @" 请输入验证码";
    _verify_code_input.backgroundColor=[UIColor clearColor];
    _verify_code_input.textAlignment = NSTextAlignmentLeft;
    _verify_code_input.layer.cornerRadius = 10.0f;
    _verify_code_input.keyboardType=UIKeyboardTypeNumberPad;
    _verify_code_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_verify_code_input becomeFirstResponder];
    _verify_code_input.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _verify_code_input.leftViewMode = UITextFieldViewModeAlways;
    _verify_code_input.layer.borderWidth = 1.0f;
    _verify_code_input.delegate=self;
    _verify_code_input.layer.borderColor = [[UIColor grayColor] CGColor];
    [_verify_code_input addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_verify_code_input];
    send_btn=[[UIButton alloc] initWithFrame:CGRectMake(100, self.blurView.frame.origin.y+self.blurView.frame.size.height+5, self.view.bounds.size.width-200, 40)];
    [send_btn dangerStyle];
    [send_btn setTitle:@"绑定" forState:UIControlStateNormal];
    [send_btn addTarget:self action:@selector(bindPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    send_btn.enabled=NO;
    [self.view addSubview:send_btn];
    
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"cloudcheck.png"] target:self action:@selector(bindPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
}
-(void)back{
    self.confirm_back_alert=[[UIAlertView alloc] initWithTitle:@"验证码短信可能略有延迟，确定返回并重新开始？"  message:nil delegate:self cancelButtonTitle:@"等待" otherButtonTitles:@"返回", nil];
    [self.confirm_back_alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)bindPhoneNumber{
    [_verify_code_input resignFirstResponder];
    [self.service registerPhoneNumberWithPhoneNumber:_phone_number verifyCode:_verify_code_input.text successHandler:^(BOOL is_ok) {
        if(self.inside){
            [_verify_code_input resignFirstResponder];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.service fetchFirstRunData:^(BOOL isOK) {
                if (self.presentedViewController == nil)
                {
                    [self presentViewController:AppDelegate.main_vc animated:YES completion:nil];
                }
                
            } errorHandler:^(NSError *error) {
                
            }];
        }
        
    } errorHandler:^(NSError *error) {
        [self.view.window showHUDWithText:error.localizedDescription Type:ShowPhotoNo Enabled:YES];
    }];
}

-(void)textFieldDidChange:(UITextField *)textField{
    if(_verify_code_input.text.length==6){
        send_btn.enabled=YES;
    }else{
        send_btn.enabled=NO;
    }
}
@end
