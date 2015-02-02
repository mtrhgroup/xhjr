//
//  CommentsViewController.h
//  XinHuaDailyXib
//
//  Created by apple on 14/11/17.
//
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)Article *article;
@property(nonatomic,strong)Service *service;
@end
