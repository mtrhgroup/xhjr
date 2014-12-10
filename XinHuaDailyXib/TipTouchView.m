//
//  TipTouchView.m
//  XinHuaDailyXib
//
//  Created by apple on 14/12/4.
//
//

#import "TipTouchView.h"
@interface TipTouchView()
@property(nonatomic,strong)UIButton *btn;
@end
@implementation TipTouchView
@synthesize btn=_btn;
- (id)init{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.backgroundColor = [UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:70/255.0 green:184/255.0 blue:218/255.0 alpha:1] CGColor];
    _btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [_btn setTitle:@"认证失败，点击重新认证" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    [self hide];
    return self;
}
-(void)click{
    [self.delegate tipTouchViewClicked];
}
-(void)hide{
    self.hidden=YES;
}
-(void)show{
    [self.superview bringSubviewToFront:self];
    self.hidden=NO;
}
@end
