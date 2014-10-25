//
//  FeedBackToAuthorViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 13-5-15.
//
//

#import "FeedBackToEditorViewController.h"
#import "NavigationController.h"
#import "UIPlaceHolderTextView.h"
#import "UIWindow+YzdHUD.h"
#import "AMBlurView.h"

@interface FeedBackToEditorViewController ()
@property (nonatomic,strong) AMBlurView *blurView;
@property(nonatomic,strong)Service *service;
@end

@implementation FeedBackToEditorViewController
@synthesize contentTV;
@synthesize article=_article;
@synthesize waitingAlert;
@synthesize mode;
@synthesize service=_service;

-(void)showToast:(NSNotification*) notification{
//    [self.view hideToastActivity];
//    NSString *info=[[notification userInfo] valueForKey:@"data"];
//    [self.view makeToast:info
//                duration:2.0
//                position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
}
- (void) viewDidLayoutSubviews {
    // only works for iOS 7+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        // snaps the view under the status bar (iOS 6 style)
        viewBounds.origin.y = topBarOffset*-1;
        
        // shrink the bounds of your view to compensate for the offset
        //viewBounds.size.height = viewBounds.size.height -20;
        self.view.bounds = viewBounds;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title=@"稿件反馈";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"regsn_bg.png"]];
    
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(10.f, 10, 300, 140)];
    [self.blurView.layer setMasksToBounds:YES];
    [self.blurView.layer setCornerRadius:10];
    //[self.blurView setAlpha:0.6];
    [[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:[self blurView]];
    
    
    UIPlaceHolderTextView* content = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 20, 280, 120)];
    // content.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    content.layer.cornerRadius = 10.0f;
    [content setFont:[UIFont systemFontOfSize:17 ]];
    content.layer.borderWidth = 0.2f;
    content.backgroundColor=[UIColor clearColor];
    content.layer.borderColor = [[UIColor grayColor] CGColor];
    content.placeholder = @"输入对稿件的反馈意见发送给新华社";
    content.placeholderColor=[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
    content.contentInset = UIEdgeInsetsMake(2,2,2,2);
    self.contentTV=content;
    [self.view addSubview:content];
    [self.contentTV becomeFirstResponder];
    
    [self makeWaitingAlert];
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [((NavigationController *)self.navigationController) setRightButtonWithImage:[UIImage imageNamed:@"forward.png"] target:self action:@selector(send_Message) forControlEvents:UIControlEventTouchUpInside];
}
-(void)makeWaitingAlert{
    self.waitingAlert = [[UIAlertView alloc]initWithTitle:@"请等待"
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil];
    
}
-(void)showWaitingAlert{
    [self.waitingAlert show];
    UIActivityIndicatorView*activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activeView.center = CGPointMake(waitingAlert.bounds.size.width/2.0f, waitingAlert.bounds.size.height-40.0f);
    [activeView startAnimating];
    [waitingAlert addSubview:activeView];
}
-(void)hideWaitingAlert{
    [self.waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)send_Message{
    NSString *contentStr=self.contentTV.text;
    if(contentStr==nil||[contentStr isEqualToString:@""]){
        [self showAlertText:@"请输入内容"];
        return;
    }
   [self.service feedbackArticleWithContent:contentStr article:self.article successHandler:^(BOOL is_ok) {
     
   } errorHandler:^(NSError *error) {
      
   }];
}
- (void)showAlertText:(NSString*)string
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
