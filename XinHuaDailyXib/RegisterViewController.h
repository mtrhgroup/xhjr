//
//  RegisterViewController.h
//  NewsLetter
//
//  Created by apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsRegisterTask.h"
#import "ChannelViewController.h"
@interface RegisterViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UITextField *snInput;
@property (strong, nonatomic) UIButton *regBtn;
@property (strong,nonatomic) UIButton *collageBtn;
@property (strong,nonatomic)UIAlertView *waitingAlert;

@property(strong,strong)ChannelViewController *channel_vc;
@end
