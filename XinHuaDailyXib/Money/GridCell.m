//
//  GridCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "GridCell.h"
#import "ALImageView.h"
@implementation GridCell{
    UILabel *label;
}


- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(5,12, frameRect.size.width-5, 40)];

        label.text = @"";
        label.textColor = [UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:22];
        label.layer.borderWidth=1;
        label.backgroundColor=[UIColor clearColor];
        label.layer.borderColor=[[UIColor colorWithRed:0x22/255.0 green:0x8c/255.0 blue:0xbe/255.0 alpha:1] CGColor];
        [[self contentView] addSubview:label];
    }
    return self;
}
-(void)setKeyword:(Keyword *)keyword{
    label.text=keyword.keyword_name;
}


@end
