//
//  KidsDefaultView.m
//  kidsgarden
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "DefaultView.h"
#import "ALImageView.h"
@interface DefaultView()
{
    UIImageView * bg;
    ALImageView *coverimageView;
    AppInfo *_app_info;
    NSDate *_startup_time;
    BOOL canEnter;
}
@property(nonatomic,assign)NSTimeInterval lasting_ms;
@end
@implementation DefaultView
@synthesize service;
@synthesize lasting_ms=_lasting_ms;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lasting_ms=5.0f;
        self.service=AppDelegate.service;
        UIImageView *defaultImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if(frame.size.height==568.0){
            defaultImageView.image=[UIImage imageNamed:@"Default~iphone.png"] ;
        }else{
            defaultImageView.image=[UIImage imageNamed:@"Default.png"] ;
        }
        [self addSubview:defaultImageView];
        _startup_time=[NSDate date];
        [self setupCoverImage];
        UIButton *enterBtn=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-100,20,88,40)];
        [enterBtn setBackgroundImage:[UIImage imageNamed:@"skip.png"] forState:UIControlStateNormal];
        [enterBtn addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enterBtn];
        [self loadDataForMainVC];
        NSTimeInterval need_waiting_ms=_lasting_ms-[self consumedTime];
        if(need_waiting_ms>0){
            [self performSelector:@selector(hide) withObject:nil afterDelay:need_waiting_ms];
        }else{
            [self hide];
        }
    }
    return self;
}

-(void)setupCoverImage{
    [service fetchAppInfo:^(AppInfo *app_info) {
        if(coverimageView==nil)
            coverimageView = [[ALImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-100)];
        coverimageView.imageURL = app_info.advPagePath;
        [self addSubview:coverimageView];
        coverimageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAD)];
        [coverimageView addGestureRecognizer:singleTap];
    } errorHandler:^(NSError *error) {
       // <#code#>
    }];

}
-(NSTimeInterval)consumedTime{
    NSDate *now=[NSDate date];
    NSTimeInterval date1=[now timeIntervalSinceReferenceDate];
    NSTimeInterval date2=[_startup_time timeIntervalSinceReferenceDate];
    NSTimeInterval interval=date1-date2;
    return interval;
}
-(void)openAD{
    self.hidden=YES;
//    if(_app_info.advPagePath!=nil&&[self.delegate respondsToSelector:@selector(openADWithURL:)]){
//        [self.delegate openADWithURL:_app_info.advPagePath];
//    }
}
-(void)loadDataForMainVC{
    if([self.delegate respondsToSelector:@selector(loadDataForMainVC)]){
        [self.delegate loadDataForMainVC];
    }
}
-(void)show{
    [self setAlpha:1.0];
}
-(void)skip{
    self.hidden=YES;
}
-(void)hide{
    [self setAlpha:1.0];
    [UIView animateWithDuration:2.0f animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
       [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];

}
@end
