//
//  ListFooterView.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/2.
//
//

#import "ListFooterView.h"

@implementation ListFooterView{
    FooterState _state;
    UIButton *_load_btn;
    UIActivityIndicatorView *_activity_indicator;
}
- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _state=Busy;
        _load_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _load_btn.frame = CGRectMake(10, 5, frameRect.size.width-20, 34);
        [_load_btn setTitle:@"显示下20条" forState:UIControlStateNormal];
        [_load_btn setTitle:@"正在载入" forState:UIControlStateDisabled];
        _load_btn.backgroundColor=[UIColor whiteColor];
        [_load_btn.layer setMasksToBounds:YES];
        [_load_btn.layer setCornerRadius:4.0];
        [_load_btn.layer setBorderWidth:0.1];
        _load_btn.layer.shadowColor=[[UIColor grayColor] CGColor];
        _load_btn.tintColor=[UIColor blackColor];
        [_load_btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        _activity_indicator =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_load_btn addSubview:_activity_indicator];
         _activity_indicator.frame=CGRectMake(_load_btn.titleLabel.frame.origin.x-_activity_indicator.frame.size.width-30, (_load_btn.frame.size.height-_activity_indicator.frame.size.height)/2, _activity_indicator.frame.size.width, _activity_indicator.frame.size.height);
        [self addSubview:_load_btn];
        
    }
    return self;
}
-(void)setState:(FooterState)state{
    if(state==Busy){
        _state=Busy;
        _load_btn.enabled=NO;
        [_activity_indicator startAnimating];
    }else if(state==Idle){
        _state=Idle;
        _load_btn.enabled=YES;
        [_activity_indicator stopAnimating];
    }
}
-(void)click{
    [self.delegate touchViewClicked];
}
@end
