//
//  KidsNavigationController.m
//  kidsgarden
//
//  Created by apple on 14/7/21.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "NavigationController.h"
#import "ArticleViewController.h"
#import "CommentsViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Alpha.h"
#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

@interface NavigationController ()<UIGestureRecognizerDelegate>{
    CGPoint startPoint;
    UIImageView *lastScreenShotView;// view
    UIImageView *lastScreenShotViewEffects;
    UIView *pushView;
    UIViewController *_toPushVC;
    int direction;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSMutableArray *screenShotList;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, strong) UIGestureRecognizer *gesture;
@end
static CGFloat offset_float = 0.65;// 拉伸参数
static CGFloat min_distance = 100;// 最小回弹距离
@implementation NavigationController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSMutableArray *)screenShotList {
    if (!_screenShotList) {
        _screenShotList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _screenShotList;
}
// get the current view screen shot
- (UIImage *)capturePushView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, self.view.opaque, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
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
    self.gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self   action:@selector(paningGestureReceive:)];
    //[self.gesture delaysTouchesBegan];
    self.gesture.enabled=NO;
    [self.view addGestureRecognizer:self.gesture];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    // 有动画用自己的动画
    if (animated) {
        [self popAnimation];
        return nil;
    } else {
        return [super popViewControllerAnimated:animated];
    }
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.gesture.enabled=YES;
    [self.screenShotList addObject:[self capture]];
    [super pushViewController:viewController animated:(BOOL)animated];
}

- (void) popAnimation {
    if (self.viewControllers.count == 1) {
        self.gesture.enabled=NO;
        return;
    }
    if (!self.backGroundView) {
        CGRect frame = self.view.frame;
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        _backGroundView.backgroundColor = [UIColor blackColor];
        
    }
    
    [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
    
    _backGroundView.hidden = NO;
    
    if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
    
    UIImage *lastScreenShot = [self.screenShotList lastObject];
    
    lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    
    lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float),0,320,MainScreenHeight};
    
    [self.backGroundView addSubview:lastScreenShotView];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self moveViewWithX:320];
        
    } completion:^(BOOL finished) {
        [self gestureAnimation:NO];
        
        CGRect frame = self.view.frame;
        
        frame.origin.x = 0;
        
        self.view.frame = frame;
        
        _isMoving = NO;
        
        self.backGroundView.hidden = YES;
    }];
}

#pragma mark - Utility Methods -
// get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position when paning
- (void)moveViewWithX:(float)x
{
    x = x>320?320:x;
    
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    // TODO
    lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float)+x*offset_float,0,320,MainScreenHeight};
    lastScreenShotViewEffects.frame=(CGRect){-(MainScreenWidth*offset_float)+x*offset_float,0,320,MainScreenHeight};
    if(x >= 0 && x <= 300.0) {
        float percent = x/300.0;
        lastScreenShotViewEffects.alpha = 1-percent;
    } else if (x > 300.0){
        lastScreenShotViewEffects.alpha = 0;
    } else if (x < 0) {
        lastScreenShotViewEffects.alpha = 1;
    }
}

- (void)moveInComingViewWithX:(float)x
{
    x = x>320?320:x;
    x = x<0?0:x;
    CGRect frame = self.view.frame;
    frame.origin.x = MainScreenWidth-x;
    self.view.frame = frame;
    lastScreenShotView.frame = (CGRect){-x*offset_float,0,320,MainScreenHeight};
    lastScreenShotViewEffects.frame=(CGRect){-x*offset_float,0,320,MainScreenHeight};
    if(x >= 0 && x <= 200.0) {
        float percent = x/200.0;
        lastScreenShotViewEffects.alpha = percent;
    } else if (x > 200.0){
        lastScreenShotViewEffects.alpha = 1;
    } else if (x < 0) {
        lastScreenShotViewEffects.alpha = 0;
    }
}

- (void)gestureAnimation:(BOOL)animated {
    [self.screenShotList removeLastObject];
    [super popViewControllerAnimated:animated];
}

#pragma mark - Gesture Recognizer -
UIImage *currentScreentShot;
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1) {
        self.gesture.enabled=NO;
        return;
    }
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        direction=0;
        startPoint = touchPoint;
        currentScreentShot=[self capture];
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        if(direction==-1){
            if (touchPoint.x - startPoint.x > min_distance)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:MainScreenWidth];
                } completion:^(BOOL finished) {
                    [self gestureAnimation:NO];
                    CGRect frame = self.view.frame;
                    frame.origin.x = 0;
                    self.view.frame = frame;
                    _isMoving = NO;
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:0];
                } completion:^(BOOL finished) {
                    _isMoving = NO;
                    self.backGroundView.hidden = YES;
                }];
                
            }
        }else if(direction==1){
            if (startPoint.x - touchPoint.x > min_distance)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveInComingViewWithX:MainScreenWidth];
                } completion:^(BOOL finished) {
                    _isMoving = NO;
                    self.gesture.enabled=YES;
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveInComingViewWithX:0];
                } completion:^(BOOL finished) {
                    _isMoving = NO;
                    self.gesture.enabled=YES;
                    [self gestureAnimation:NO];
                    CGRect frame = self.view.frame;
                    frame.origin.x = 0;
                    self.view.frame = frame;
                    self.backGroundView.hidden = YES;
                }];
                
            }
        }else if(touchPoint.x-startPoint.x<0){
            if(direction==1){
                
            }else if(direction==-1){
                
            }
        }
        return;
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            
            self.backGroundView.hidden = YES;
        }];
        
        return;
    }
    // it keeps move with touch
    if (_isMoving) {
        if(startPoint.x-touchPoint.x>0){
            if(direction==0){           
                if([[self.viewControllers lastObject] isKindOfClass:[ArticleViewController class]]){
                    direction=1;
                    CommentsViewController *vc=[[CommentsViewController alloc] init];
                    vc.service=((ArticleViewController *)[self.viewControllers lastObject]).service;
                    vc.article=((ArticleViewController *)[self.viewControllers lastObject]).article;
                    [self.screenShotList addObject:currentScreentShot];
                    [super pushViewController:vc animated:NO];
                    if (!self.backGroundView) {
                        CGRect frame = self.view.frame;
                        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                        _backGroundView.backgroundColor = [UIColor blackColor];
                    }
                    [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
                    _backGroundView.hidden = NO;
                    if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
                    if(lastScreenShotViewEffects)[lastScreenShotViewEffects removeFromSuperview];
                    UIImage *lastScreenShotEffects=[currentScreentShot applyLightEffect];
                    lastScreenShotView = [[UIImageView alloc] initWithImage:currentScreentShot];
                    lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float),0,320,MainScreenHeight};
                    lastScreenShotViewEffects=[[UIImageView alloc] initWithImage:lastScreenShotEffects];
                    lastScreenShotViewEffects.frame = (CGRect){-(MainScreenWidth*offset_float),0,320,MainScreenHeight};
                    [self.backGroundView addSubview:lastScreenShotView];
                    [self.backGroundView addSubview:lastScreenShotViewEffects];
                }
            }
            if(direction==1){
                [self moveInComingViewWithX:startPoint.x-touchPoint.x];
            }
        }else if(startPoint.x-touchPoint.x<0){
            if(direction==0){
                direction=-1;
                if (!self.backGroundView) {
                    CGRect frame = self.view.frame;
                    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                    _backGroundView.backgroundColor = [UIColor blackColor];
                }
                [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
                _backGroundView.hidden = NO;
                if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
                if(lastScreenShotViewEffects)[lastScreenShotViewEffects removeFromSuperview];
                UIImage *lastScreenShot = [self.screenShotList lastObject];
                UIImage *lastScreenShotEffects=[lastScreenShot applyLightEffect];
                lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
                lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float),0,320,MainScreenHeight};
                lastScreenShotViewEffects=[[UIImageView alloc] initWithImage:lastScreenShotEffects];
                lastScreenShotViewEffects.frame = (CGRect){-(MainScreenWidth*offset_float),0,320,MainScreenHeight};
                [self.backGroundView addSubview:lastScreenShotView];
                [self.backGroundView addSubview:lastScreenShotViewEffects];
            }
            if(direction==-1){
                [self moveViewWithX:touchPoint.x - startPoint.x];
            }
        }
    }
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
