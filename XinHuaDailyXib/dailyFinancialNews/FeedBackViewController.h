//
//  FeedBackViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface FeedBackViewController : UIViewController<UITextViewDelegate>
@property(nonatomic,strong)Article *article;
@property(nonatomic,strong)UITextView *contentTV;
@property (strong,nonatomic)UIAlertView *waitingAlert;
@property(nonatomic)int mode;
@end
