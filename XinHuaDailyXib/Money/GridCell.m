//
//  GridCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "GridCell.h"
#import "ALImageView.h"
#import "GlobalVariablesDefine.h"
@implementation GridCell{
    UILabel *label;
    NSString *_tag;
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
        label.layer.borderColor=[Line_BG_COLOR CGColor];
        [[self contentView] addSubview:label];
    }
    return self;
}

-(void)setTag:(NSString *)tag{
    if(_tag==nil||![_tag isEqualToString:tag]){
        _tag=tag;
        label.text=tag;
    }
}


@end
