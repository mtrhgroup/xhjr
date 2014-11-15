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
@interface VerifyCodeSubmitViewController ()
@property (nonatomic,strong) AMBlurView *blurView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIAlertView *confirm_back_alert;
@end
@implementation VerifyCodeSubmitViewController
@synthesize verify_code_input=_verify_code_input;
@synthesize phone_number=_phone_number;
@synthesize service=_service;
@synthesize confirm_back_alert=_confirm_back_alert;
- (void)viewDidLoad
{
    self.title=@"填写验证码";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"regsn_bg.png"]];
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(10.f, 40+44, 300, 60)];
    [self.blurView.layer setMasksToBounds:YES];
    [self.blurView.layer setCornerRadius:10];
    //[self.blurView setAlpha:0.6];
    [[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:[self blurView]];
    _verify_code_input = [[UITextField alloc] initWithFrame:CGRectMake(20, 50+44, 280, 40)];
    _verify_code_input.placeholder = @" 请输入验证码";
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
    self.confirm_back_alert=[[UIAlertView alloc] initWithTitle:@"验证码短信可能略有延迟，确定返回并重新开始？"  message:nil delegate:self cancelButtonTitle:@"等待" otherButtonTitles:@"返回", nil];
    [self.confirm_back_alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)bindPhoneNumber{
    [self.service registerPhoneNumberWithPhoneNumber:_phone_number verifyCode:_verify_code_input.text successHandler:^(BOOL is_ok) {
        [self.service fetchChannelsFromNET:^(NSArray *channels) {
            AppDelegate.channel=[self.service fetchMRCJChannelFromDB];

            [self presentViewController:AppDelegate.main_vc animated:YES completion:nil];
        } errorHandler:^(NSError *error) {
            //
        }];
        
    } errorHandler:^(NSError *error) {
        [self.view.window showHUDWithText:error.localizedDescription Type:ShowPhotoNo Enabled:YES];
    }];
}
@end
