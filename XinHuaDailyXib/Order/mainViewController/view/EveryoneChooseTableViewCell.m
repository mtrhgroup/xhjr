//
//  EveryoneChooseChoTableViewCell.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/18.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "EveryoneChooseTableViewCell.h"
#import "Util.h"
#define HotForecastTableViewCellTitleFontSize 18
#define HotForecastTableViewCellContentFontSize 15
#define HotForecastTableViewCellFromHintFontSize 13

@interface EveryoneChooseTableViewCell()
{
    UILabel *_titlelabel;
    UILabel *_content;
//    UILabel *_fromHint;
    UILabel *_fromLabel;
//    UILabel *_fromTimeHint;
    UILabel *_fromTimeLabel;
}
@end
@implementation EveryoneChooseTableViewCell

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
    _titlelabel = [[UILabel alloc]init];
    _titlelabel.font = [UIFont systemFontOfSize:HotForecastTableViewCellTitleFontSize];
    _titlelabel.backgroundColor = [UIColor clearColor];
    _titlelabel.numberOfLines = 0;
    [self addSubview:_titlelabel];
    
    _content = [[UILabel alloc]init];
    _content.backgroundColor = [UIColor clearColor];
    _content.font = [UIFont systemFontOfSize:HotForecastTableViewCellContentFontSize];
    _content.numberOfLines = 0;
//    _content.lineBreakMode =  NSLineBreakByCharWrapping;
    _content.textColor = [UIColor grayColor];
    [self addSubview:_content];
    
    _fromLabel = [[UILabel alloc]init];
    _fromLabel.font = [UIFont systemFontOfSize:HotForecastTableViewCellFromHintFontSize];
    _fromLabel.textColor = [UIColor grayColor];
    _fromLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_fromLabel];
    
    _fromTimeLabel = [[UILabel alloc]init];
    _fromTimeLabel.font = [UIFont systemFontOfSize:HotForecastTableViewCellFromHintFontSize];
    _fromTimeLabel.textColor = [UIColor grayColor];
    _fromTimeLabel.backgroundColor = [UIColor clearColor];
    _fromTimeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_fromTimeLabel];
}

#pragma mark 设置控件长宽
-(void)setStatus:(HotForecastModel *)model
{
    _titlelabel.frame = CGRectMake(10, 10, 260, model.titleSize.height);
    _titlelabel.text = model.title;
    
    _content.frame = CGRectMake(_titlelabel.frame.origin.x, _titlelabel.frame.origin.y+_titlelabel.frame.size.height+5, _titlelabel.frame.size.width,model.contentSize.height);
    _content.text = model.content;

//    _fromHint.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y+_content.frame.size.height+5, 45,12);
    
    _fromLabel.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y+_content.frame.size.height+5, RIGHTVIEWWIGHT/2-10,12);
    _fromLabel.text = [NSString stringWithFormat:@"发起人: %@",[self getUserName:model.user]];
    
    _fromTimeLabel.frame = CGRectMake(280/2, _fromLabel.frame.origin.y, RIGHTVIEWWIGHT/2-10,12);

//    NSArray *timeArray = [[model.noticeTime componentsSeparatedByString:@" "][0]componentsSeparatedByString:@"-"];
//    _fromTimeLabel.text = [NSString stringWithFormat:@"发起时间: %@/%@/%@",timeArray[0],timeArray[1],timeArray[2]];
    _fromTimeLabel.text = [Util wrapDateString:model.creatTime];
}

- (NSMutableString*)getUserName:(NSString*)oldName
{
    NSArray *array = [oldName componentsSeparatedByString:@"_"];
    if (array.count==1) {
        return [NSMutableString stringWithString:@"匿名用户"];
    }
    NSMutableString * string = [[NSMutableString alloc]initWithString:array[1]];
    [string replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return string;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
