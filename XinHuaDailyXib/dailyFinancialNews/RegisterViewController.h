//
//  RegisterViewController.h
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RegisterViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UITextField *phone_number_input;
@property (strong, nonatomic) UITextField *verify_code_input;
@property (strong, nonatomic) UIButton *regBtn;
@property (strong,nonatomic)UIAlertView *waitingAlert;
@property(nonatomic,assign)BOOL inside;
@end
