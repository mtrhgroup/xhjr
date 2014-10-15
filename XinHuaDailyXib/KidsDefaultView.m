//
//  KidsDefaultView.m
//  kidsgarden
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "KidsDefaultView.h"
#import "ALImageView.h"
@interface KidsDefaultView()
{
    UIImageView * bg;
    ALImageView *coverimageView;
    KidsAppCoverImage *cover_img;
    NSDate *_startup_time;
    BOOL canEnter;
}
@property(nonatomic,assign)NSTimeInterval lasting_ms;
@end
@implementation KidsDefaultView
@synthesize service;
@synthesize lasting_ms=_lasting_ms;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lasting_ms=5.0f;
        self.service=AppDelegate.content_service;
        UIImageView *defaultImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if(frame.size.height==568.0){
            defaultImageView.image=[UIImage imageNamed:@"Default~iphone.png"] ;
        }else{
            defaultImageView.image=[UIImage imageNamed:@"Default.png"] ;
        }
        [self addSubview:defaultImageView];
        _startup_time=[NSDate date];
        if([self isFirstStartup]){
            [self firstStartup];
        }else{
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
    }
    return self;
}
-(void)firstStartup{
    [service registerDevice:^(BOOL isOK) {
        if(isOK){
            [service fetchChannelsFromNET:^(NSArray *channels) {
                if([channels count]>0){
                    [self markFirstStartupSuccess];
                    [self loadDataForMainVC];
                    NSTimeInterval need_waiting_ms=_lasting_ms-[self consumedTime];
                    if(need_waiting_ms>0){
                        [self performSelector:@selector(hide) withObject:nil afterDelay:need_waiting_ms];
                    }else{
                        [self hide];
                    }
                }else{
                    [self errorReport];
                }
            } errorHandler:^(NSError *error) {
                [self errorReport];
            }];
        }else{
            [self errorReport];
        }
    } errorHandler:^(NSError * error){
        [self errorReport];
    }];
}
-(void)setupCoverImage{
    cover_img=[service fetchAppCoverImage];
    if(![cover_img isEmpty]){
        if(coverimageView==nil)
            coverimageView = [[ALImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-100)];
        coverimageView.imageURL = cover_img.url;
        [self addSubview:coverimageView];
        coverimageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAD)];
        [coverimageView addGestureRecognizer:singleTap];
    }
}
-(void)errorReport{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"初始化错误，请检查网络稍后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    exit(0);
}
-(BOOL)isFirstStartup{
    BOOL startuped=[[NSUserDefaults standardUserDefaults]  boolForKey:@"startuped"];
    return !startuped;
}
-(void)markFirstStartupSuccess{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"startuped"] ;
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
    if(cover_img.goUrl!=nil&&![cover_img.goUrl isEqual:@""]&&[cover_img.goUrl hasPrefix:@"http"]&&[self.delegate respondsToSelector:@selector(openADWithURL:)]){
        [self.delegate openADWithURL:cover_img.goUrl];
    }
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

    }];

}
@end
