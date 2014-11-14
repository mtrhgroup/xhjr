//
//  RegisterViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) UITextField *verify_code_input;
@property(strong,nonatomic)NSString *phone_number;
@property(strong,nonatomic)Service *service;
@end
