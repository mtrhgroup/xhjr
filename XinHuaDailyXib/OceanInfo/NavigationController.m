//
//  KidsNavigationController.m
//  kidsgarden
//
//  Created by apple on 14/7/21.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *color=[UIColor whiteColor];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys: color,UITextAttributeTextColor, [UIFont fontWithName:@"Arial" size:24.0f], UITextAttributeFont,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,nil];
    self.navigationBar.titleTextAttributes=dict;
    if(lessiOS7){
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg_iOS6.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg_iOS7.png"] forBarMetrics:UIBarMetricsDefault];
    }
    //[self.navigationBar setBarTintColor:[UIColor redColor]];

}
-(void)showLeftMenu{
    [AppDelegate.main_vc toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)setLeftButtonWithImage:(UIImage *)img target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    UIButton *left_btn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [left_btn setBackgroundImage:img forState:UIControlStateNormal];
    [left_btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if(lessiOS7){
        negativeSpacer.width=0;
    }else{
        negativeSpacer.width=-10;
    }
    UIBarButtonItem *left_btn_item=[[UIBarButtonItem alloc] initWithCustomView:left_btn];
    [self.visibleViewController.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,left_btn_item,nil] animated:YES];
}
-(void)setRightButtonWithImage:(UIImage *)img target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    UIButton *right_btn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [right_btn setBackgroundImage:img forState:UIControlStateNormal];
    [right_btn addTarget:target action:action forControlEvents:controlEvents];
    UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if(lessiOS7){
        negativeSpacer.width=0;
    }else{
        negativeSpacer.width=-15;
    }
    UIBarButtonItem *right_btn_item=[[UIBarButtonItem alloc] initWithCustomView:right_btn];
    [self.visibleViewController.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,right_btn_item,nil] animated:YES];
}
-(void)setRightButtonWithString:(NSString *)string target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    UIButton *right_btn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,30,40)];
    [right_btn setTitle:string forState:UIControlStateNormal];
    [right_btn addTarget:target action:action forControlEvents:controlEvents];
    UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if(lessiOS7){
        negativeSpacer.width=0;
    }else{
        negativeSpacer.width=-20;
    }
    negativeSpacer.width=0;
    UIBarButtonItem *right_btn_item=[[UIBarButtonItem alloc] initWithCustomView:right_btn];
    [self.visibleViewController.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,right_btn_item,nil] animated:YES];
}

@end
