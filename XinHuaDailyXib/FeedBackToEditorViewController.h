//
//  FeedBackToAuthorViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 13-5-15.
//
//

#import <UIKit/UIKit.h>

@interface FeedBackToEditorViewController : UIViewController
@property(nonatomic,strong)NSString *articleId;
@property(nonatomic,strong)UITextView *contentTV;
@property (strong,nonatomic)UIAlertView *waitingAlert;
@property(nonatomic)int mode;
@end
