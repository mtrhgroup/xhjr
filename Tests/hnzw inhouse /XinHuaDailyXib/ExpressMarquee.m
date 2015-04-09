//
//  MyMarquee.m
//  XinHuaDailyXib
//
//  Created by apple on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExpressMarquee.h"
#import <QuartzCore/QuartzCore.h>
@implementation ExpressMarquee
@synthesize showText;
@synthesize showLap;
@synthesize moveWidth;
@synthesize labelText;
NSTimer *timer;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setShowLap:2];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSLog(@"Marquee drawRect...");
    
}

-(void)calculateShowFrame{
    int tempx=0;
    for(UILabel * label in self.subviews){
        [label removeFromSuperview];
    }
    if(showText){
        NSString *textContent=[showText objectForKey:@"TEXT_CONTENT"];
        UIColor *textColor=[showText objectForKey:@"TEXT_COLOR"];
        UIFont *textFont=[showText objectForKey:@"TEXT_FONT"];
        
        CGSize textContentSize=[textContent sizeWithFont:textFont];
        CGFloat textContentW=textContentSize.width;
        CGFloat textContentH=textContentSize.height;
        self.labelText=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, textContentW, textContentH)] autorelease];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [labelText setTextAlignment:UITextAlignmentCenter];
        [labelText setFont:textFont];
        [labelText setTextColor:textColor];
        [labelText setText:textContent];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.type = @"cube";
        animation.subtype = kCATransitionFromTop;
        [self.layer addAnimation:animation forKey:@"animation"];
        [self addSubview:labelText];
        tempx+=textContentW+20; 
        self.moveWidth=tempx;
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(update) userInfo:nil repeats:NO];
    }
    
    
}
-(void)update{
    NSLog(@"update");
    CGRect frame=self.labelText.frame;
    frame.origin.x=0;
    self.labelText.frame=frame;
    NSLog(@"moveWidth %d",moveWidth);
    if(moveWidth>290){
    [UIView beginAnimations:@"MarqueeAnimation" context:NULL];
    [UIView setAnimationDuration:8.0f*(moveWidth-290)/290];
     //       [UIView setAnimationDuration:2.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:showLap];
    frame=self.labelText.frame;
    frame.origin.x=290-moveWidth;
    self.labelText.frame=frame;
    [UIView commitAnimations];
    }
    timer=nil;
}
-(void)clickMarquee{
    NSLog(@"clickMarquee... ");
    // NSLog(@"clickMarquee... %d",((UILabel *)sender).tag);
}
-(void)dealloc{
    [super dealloc];
    [showText release];
    [labelText release];
}
@end
