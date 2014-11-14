//
//  RightFunctionCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "RightFunctionCell.h"

@implementation RightFunctionCell{
    UIImageView *_icon;
    UILabel *_label;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        _icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_Pointsubject_default.png"]];
        _icon.frame=CGRectMake(45, 12, 20, 20);
        [[self contentView] addSubview:_icon];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(70,0,120,44)];
        _label.text=@"点题";
        _label.textColor=[UIColor whiteColor];
        _label.backgroundColor=[UIColor clearColor];
        _label.textAlignment=NSTextAlignmentLeft;
        [[self contentView] addSubview:_label];
        UIImageView *dot_line_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, self.bounds.size.width, 1)];
        [self addSubview:dot_line_view];
        UIGraphicsBeginImageContext(dot_line_view.frame.size);   //开始画线
        [dot_line_view.image drawInRect:CGRectMake(0, 0, dot_line_view.frame.size.width, 1)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
        float lengths[] = {4,4};
        CGContextRef line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
        CGContextAddLineToPoint(line, self.bounds.size.width, 0.0);
        CGContextStrokePath(line);
        dot_line_view.image = UIGraphicsGetImageFromCurrentImageContext();
    }
    return self;
}
-(void)setIcon_image:(UIImage *)icon_image{
    _icon.image=icon_image;
}

-(void)setLabel_text:(NSString *)label_text{
    _label.text=label_text;
}
@end
