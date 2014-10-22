//
//  KidsTouchRefreshView.m
//  kidsgarden
//
//  Created by apple on 14/6/30.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "CoverTouchView.h"
@interface CoverTouchView()
@property(nonatomic,strong)UIButton *touchView;
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation CoverTouchView
@synthesize imageView=_imageView;
@synthesize touchView=_touchView;
@synthesize delegate=_delegate;
-(id)initWithImage:(UIImage *)image frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        UIImageView *image_view=[[UIImageView alloc]initWithImage:image];
        float x=(frame.size.width-image.size.width)/2;
        float y=(frame.size.height-image.size.height)/2;
        image_view.frame=CGRectMake(x, y, image.size.width, image.size.height);
        [self addSubview:image_view];
        self.touchView = [[UIButton alloc] initWithFrame:frame];
        [self.touchView addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.touchView];
        self.hidden=YES;
    }
    return self;
}

-(void)click{
    [self.delegate touchViewClicked];
}
-(void)hide{
    self.hidden=YES;
}
-(void)show{
    self.hidden=NO;
}

@end
