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
}
- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {

        _date_lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frameRect.size.width-20, 34)];
        _date_lbl.backgroundColor=[UIColor whiteColor];
        _date_lbl.textColor=[UIColor redColor];
        _date_lbl.textAlignment=NSTextAlignmentRight;
        [self addSubview:_date_lbl];
        
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
