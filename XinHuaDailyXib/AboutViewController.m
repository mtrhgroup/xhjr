//
//  XDAboutViewController.m
//  XDailyNews
//
//  Created by peiqiang li on 11-12-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "DeviceInfo.h"
#import "NavigationController.h"
#import "AMBlurView.h"
@interface AboutViewController()
@property (nonatomic,strong)AMBlurView *blurView;
@property(nonatomic,strong)UILabel *sn_lbl;
@end
@implementation AboutViewController
@synthesize sn_lbl=_sn_lbl;
@synthesize blurView=_blurView;

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
-(void)viewWillAppear:(BOOL)animated{
    if(AppDelegate.user_defaults.sn.length==0){
        _sn_lbl.text=@"";
    }else{
        _sn_lbl.text=[NSString stringWithFormat:@"%@",AppDelegate.user_defaults.sn];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"客服电话";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"regsn_bg.png"]];
    UIView* uiv = [[UIView alloc] initWithFrame:CGRectMake(5, 88, 310, 230)];
    uiv.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"about_gray.png"]];
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:CGRectMake(5, 88, 310, 230)];
    [self.blurView.layer setMasksToBounds:YES];
    [self.blurView.layer setCornerRadius:10];
    [self.blurView setBlurTintColor:[UIColor blackColor]];
    [[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:[self blurView]];
    
    UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 64, 64)];
    logo.image=[UIImage imageNamed:@"Icon@2x.png"];
    [self.blurView addSubview:logo];
    NSString* appversion =  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    UILabel* lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 90, 20)];
    lab1.backgroundColor = [UIColor clearColor];
    lab1.font = [UIFont fontWithName:@"Arial" size:16];
    lab1.textColor = [UIColor whiteColor];
    lab1.text =  @"授权码:";
    [self.blurView addSubview:lab1];
    
    
    self.sn_lbl = [[UILabel alloc] initWithFrame:CGRectMake(90, 100, 220, 20)];
    self.sn_lbl.backgroundColor = [UIColor clearColor];
    self.sn_lbl.font = [UIFont fontWithName:@"Arial" size:16];
    self.sn_lbl.text=AppDelegate.user_defaults.sn;
    self.sn_lbl.textColor = [UIColor whiteColor];
    [self.blurView addSubview:self.sn_lbl];
    
    
    UILabel* lab3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 90, 20)];
    lab3.backgroundColor = [UIColor clearColor];
    lab3.font = [UIFont fontWithName:@"Arial" size:16];
    lab3.textColor = [UIColor whiteColor];
    lab3.text =  @"版本信息:";
    [self.blurView addSubview:lab3];
    
    
    UILabel* lab4 = [[UILabel alloc] initWithFrame:CGRectMake(90, 120, 220, 20)];
    lab4.backgroundColor = [UIColor clearColor];
    lab4.font = [UIFont fontWithName:@"Arial" size:16];
    lab4.textColor = [UIColor whiteColor];
    lab4.text =  appversion;
    [self.blurView addSubview:lab4];
    UILabel* lab7 = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 90, 20)];
    lab7.backgroundColor = [UIColor clearColor];
    lab7.font = [UIFont fontWithName:@"Arial" size:16];
    lab7.textColor = [UIColor whiteColor];
    lab7.text =  @"客服电话:";
    [self.blurView addSubview:lab7];
    UILabel* lab8 = [[UILabel alloc] initWithFrame:CGRectMake(90, 140, 220, 20)];
    lab8.backgroundColor = [UIColor clearColor];
    lab8.font = [UIFont fontWithName:@"Arial" size:16];
    lab8.textColor = [UIColor blueColor];
    lab8.text =  @"024-23822598";
    [self.blurView addSubview:lab8];
    lab8.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telToMe:)];
    [lab8 addGestureRecognizer:singleTap];

    UILabel* labRight = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 250, 20)];
    labRight.backgroundColor = [UIColor clearColor];
    labRight.font = [UIFont fontWithName:@"Arial" size:16];
    labRight.textColor = [UIColor whiteColor];
    labRight.text =  @"©新华时讯通移动信息服务平台";
    [self.blurView addSubview:labRight];
    [self.view addSubview:self.blurView];
    
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)returnclick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)telToMe:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://02423828522"]];
}
- (void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
