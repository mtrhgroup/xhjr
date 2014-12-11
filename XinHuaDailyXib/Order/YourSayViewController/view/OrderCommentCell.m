//
//  CommentCell.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/27.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "OrderCommentCell.h"
#import "UIColor+Hex.h"
@interface OrderCommentCell()
{
    UILabel *_author;
    UILabel *_content;
    UILabel *_time;
    UIView *line;
}
@end
@implementation OrderCommentCell

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
    _author = [[UILabel alloc]init];
    _author.font = [UIFont systemFontOfSize:13];
    _author.textColor = [UIColor colorWithHexString:@"#1163c7"];
    _author.backgroundColor = [UIColor clearColor];
    [self addSubview:_author];
    
    _time = [[UILabel alloc]init];
    _time.font = [UIFont systemFontOfSize:12];
    _time.textAlignment = NSTextAlignmentRight;
    _time.textColor = [UIColor colorWithHexString:@"#a2a2a2"];
    _time.backgroundColor = [UIColor clearColor];
    [self addSubview:_time];
    
    _content = [[UILabel alloc]init];
    _content.backgroundColor = [UIColor clearColor];
    _content.font = [UIFont systemFontOfSize:15];
    _content.numberOfLines = 0;
    _content.lineBreakMode =  NSLineBreakByCharWrapping;
    _content.textColor = [UIColor colorWithHexString:@"#343434"];
    [self addSubview:_content];
    
    line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#c7c7c9"];
    [self addSubview:line];

}

-(void)setStatus:(CommentModel *)model
{
    _author.frame = CGRectMake(15, 13, RIGHTVIEWWIGHT-90, 22);
    _author.text = [self getUserName:model.author];
    
    _content.frame = CGRectMake(_author.frame.origin.x, _author.frame.origin.y+_author.frame.size.height, _author.frame.size.width,model.commentContentSize.height);
    _content.text = model.commentContent;
    
    _time.frame = CGRectMake(_content.frame.origin.x+_content.frame.size.width, 24, RIGHTVIEWWIGHT-_content.frame.origin.x-_content.frame.size.width-10, 12);
    _time.text = model.forNow;
    
    line.frame = CGRectMake(9, model.commentContentSize.height+59, RIGHTVIEWWIGHT-18, 1);
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
