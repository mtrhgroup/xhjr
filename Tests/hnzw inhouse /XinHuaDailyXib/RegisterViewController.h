//
//  RegisterViewController.h
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsRegisterTask.h"
@interface RegisterViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>
@property (retain, nonatomic) UITextField *snInput;
@property (retain, nonatomic) UIButton *regBtn;
@property (retain,nonatomic) UIButton *collageBtn;
@property (retain,nonatomic)UIAlertView *waitingAlert;
//- (void)registger:(id)sender;
//- (void)cancel:(id)sender;
//- (void)valueChanged:(id)sender;
@end
