//
//  KidsWaitingView.m
//  kidsgarden
//
//  Created by apple on 14/6/23.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "WaitingView.h"

@implementation WaitingView{
    UIActivityIndicatorView *_indicator;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(frame.size.width/2-20, frame.size.height/2-20, 40.0f, 40.0f)];
        [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [_indicator startAnimating];
        [self addSubview:_indicator];
        self.hidden=YES;
    }
    return self;
}

-(void)hide{
    [_indicator stopAnimating];
    self.hidden=YES;
}
-(void)show{
    [_indicator startAnimating];
    self.hidden=NO;
}

@end
