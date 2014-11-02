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
}
- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _state=Busy;

    }
    return self;
}
-(void)setState:(FooterState)state{
    if(state==Busy){
        _state=Busy;
    }else if(state==Idle){
        _state=Idle;
    }
}
-(void)click{
    [self.delegate touchViewClicked];
}
@end
