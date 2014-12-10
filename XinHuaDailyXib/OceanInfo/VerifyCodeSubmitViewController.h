//
//  VerifyCodeSubmitViewController.h
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14/10/25.
//
//

#import <UIKit/UIKit.h>

@interface VerifyCodeSubmitViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *verify_code_input;
@property(strong,nonatomic)NSString *phone_number;
@property(strong,nonatomic)Service *service;
@property(nonatomic,assign)BOOL inside;
@end
