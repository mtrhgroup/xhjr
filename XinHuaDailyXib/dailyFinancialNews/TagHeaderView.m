//
//  TagHeaderView.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "TagHeaderView.h"

@implementation TagHeaderView
- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,0, frameRect.size.width-5, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"标签";
        label.textColor = [UIColor redColor];
        label.font = [UIFont fontWithName:@"Arial" size:15];
        [self addSubview:label];
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
@end
