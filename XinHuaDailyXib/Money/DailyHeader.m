//
//  DailyHeader.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14/11/15.
//
//

#import "DailyHeader.h"

@implementation DailyHeader{
    UILabel *_date_lbl;
    UIView *_bg_view;
}
- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _bg_view = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frameRect.size.width-20, 34)];
        _bg_view.backgroundColor=[UIColor whiteColor];
        [self addSubview:_bg_view];
        _date_lbl = [[UILabel alloc] initWithFrame:CGRectMake(_bg_view.frame.size.width-150-5, 5, 150, 34)];
        _date_lbl.backgroundColor=[UIColor whiteColor];
        _date_lbl.textColor=[UIColor redColor];
        _date_lbl.textAlignment=NSTextAlignmentRight;
        [self addSubview:_date_lbl];
        _bg_view.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
        _bg_view.layer.shadowOffset = CGSizeMake(0.1,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _bg_view.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        
    }
    return self;
}
-(void)setDate:(NSString *)date{
    NSString *year=[date substringWithRange:NSMakeRange (0, 4)];
    NSString *month=[date substringWithRange:NSMakeRange(5, 2)];
    NSString *day=[date substringWithRange:NSMakeRange(8, 2)];
    _date_lbl.text=[NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
}
@end
