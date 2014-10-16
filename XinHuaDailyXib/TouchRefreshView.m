//
//  KidsTouchRefreshView.m
//  kidsgarden
//
//  Created by apple on 14/6/30.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "TouchRefreshView.h"

@implementation TouchRefreshView
@synthesize touchView;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        touchView = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2-100, frame.size.height/2-100, 200.0f, 200.0f)];
        touchView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"click_reload.png"]];
        [touchView addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:touchView];
        self.hidden=YES;
    }
    return self;
}
-(void)click{
    [self.delegate clicked];
}
-(void)hide{
    self.hidden=YES;
}
-(void)show{
    self.hidden=NO;
}

@end
