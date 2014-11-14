//
//  VerifyCodeSubmitViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14/10/25.
//
//

#import "RegisterViewController.h"
#import "NavigationController.h"
#import "AMBlurView.h"
@interface RegisterViewController ()
@property (nonatomic,strong) AMBlurView *blurView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIAlertView *confirm_back_alert;
@end
@implementation RegisterViewController
@synthesize verify_code_input=_verify_code_input;
@synthesize phone_number=_phone_number;
@synthesize service=_service;
@synthesize confirm_back_alert=_confirm_back_alert;
- (void)viewDidLoad
{
    self.title=@"账号绑定";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"regsn_bg.png"]];
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(10.f, 40+44, 300, 60)];
    [self.blurView.layer setMasksToBounds:YES];
    [self.blurView.layer setCornerRadius:10];
    //[self.blurView setAlpha:0.6];
    [[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:[self blurView]];
    _verify_code_input = [[UITextField alloc] initWithFrame:CGRectMake(20, 50+44, 280, 40)];
    _verify_code_input.placeholder = @" 请输入您的授权码";
    _verify_code_input.backgroundColor=[UIColor clearColor];
    _verify_code_input.textAlignment = NSTextAlignmentLeft;
    _verify_code_input.layer.cornerRadius = 10.0f;
    _verify_code_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_verify_code_input becomeFirstResponder];
    _verify_code_input.layer.borderWidth = 1.0f;
    _verify_code_input.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:_verify_code_input];
    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"cloudcheck.png"] target:self action:@selector(bindPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
}
-(void)bindPhoneNumber{
    [self.service registerPhoneNumberWithPhoneNumber:_phone_number verifyCode:_verify_code_input.text successHandler:^(BOOL is_ok) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } errorHandler:^(NSError *error) {
        [self.view.window showHUDWithText:error.localizedDescription Type:ShowPhotoNo Enabled:YES];
    }];
}
@end
