//
//  SayContentCell.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/25.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "SayContentCell.h"
#import "UIColor+Hex.h"
@interface SayContentCell()
{
    UILabel *_title;
    UILabel *_content;
}
@end

@implementation SayContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

#pragma mark 初始化视图
-(void)initSubView
{
    _title = [[UILabel alloc]init];
    _title.font = [UIFont systemFontOfSize:20];
    _title.numberOfLines =0;
    _title.textColor = [UIColor colorWithHexString:@"#343434"];
    _title.backgroundColor = [UIColor clearColor];
    [self addSubview:_title];
    
    _content = [[UILabel alloc]init];
    _content.backgroundColor = [UIColor clearColor];
    _content.font = [UIFont systemFontOfSize:15];
    _content.numberOfLines = 0;
    _content.lineBreakMode =  NSLineBreakByCharWrapping;
    _content.textColor = [UIColor colorWithHexString:@"#343434"];
    [self addSubview:_content];
}

-(void)setStatus:(HotForecastModel*)model
{
    _title.frame = CGRectMake(10, 13, RIGHTVIEWWIGHT-20, model.titleSize.height);
    _title.text = model.title;
    
    _content.frame = CGRectMake(_title.frame.origin.x+7, _title.frame.origin.y+_title.frame.size.height+15, _title.frame.size.width-14,model.contentSize.height);
    _content.text = [NSString stringWithFormat:@"    %@",model.content];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(9, model.contentSize.height+49+model.titleSize.height, RIGHTVIEWWIGHT-18, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#c7c7c9"];
    [self addSubview:line];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
