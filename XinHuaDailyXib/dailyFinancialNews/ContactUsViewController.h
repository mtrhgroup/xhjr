//
//  ContactUsViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *emailTF;
@property(nonatomic,strong)UITextView *contentTV;
@property (strong,nonatomic)UIAlertView *waitingAlert;
@property(nonatomic)int mode;
@end
