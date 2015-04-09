//
//  FeedBackToAuthorViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 13-5-15.
//
//

#import <UIKit/UIKit.h>
#import "Article.h"
@interface FeedBackToEditorViewController : UIViewController
@property(nonatomic,strong)Article *article;
@property(nonatomic,strong)UITextView *contentTV;
@property (strong,nonatomic)UIAlertView *waitingAlert;
@property(nonatomic)int mode;
@end
