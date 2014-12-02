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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,0, frameRect.size.width-10, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"标签";
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:label];
        UIView *red_line=[[UIView alloc] initWithFrame:CGRectMake(0, 43, frameRect.size.width, 1)];
        red_line.backgroundColor=[UIColor grayColor];
        [self addSubview:red_line];

    }
    return self;
}
@end
