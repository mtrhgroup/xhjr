//
//  ContactUsViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController
@property(nonatomic,retain)UITextField *emailTF;
@property(nonatomic,retain)UITextView *contentTV;
@property (retain,nonatomic)UIAlertView *waitingAlert;
@property(nonatomic)int mode;
@end
