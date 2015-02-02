//
//  AttentionTableViewCell.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/18.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//
#define BUTTONFRAME 50
//字体大小
#define HotForecastTableViewCellTitleFontSize 20
#define HotForecastTableViewCellContentFontSize 15
#define HotForecastTableViewCellFromHintFontSize 12
#import "AttentionTableViewCell.h"
#import "UIColor+Hex.h"
#import "XHRequest.h"
#import "NSString+Addtions.h"
#import "NSString+SBJSON.h"
#import "YourSayViewController.h"

@interface AttentionTableViewCell()
{
    UILabel *_titlelabel;
    UILabel *_content_label;
    UIButton *_content;
    UIImageView*_BubbleView;
    UILabel *_fromLabel;
    UILabel *_fromHint;
    UIButton *_lookButton;
    UIButton *_sayButton;
    UIImageView *topBubble;
    UIImageView *underButtble;
    HotForecastModel *_model;
}
@end
@implementation AttentionTableViewCell
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
    
    topBubble = [[UIImageView alloc]init];
    topBubble.backgroundColor = [UIColor clearColor];
    topBubble.image = [UIImage imageNamed:@"up_border"];
    [self addSubview:topBubble];
    
    _BubbleView = [[UIImageView alloc]init];
    _BubbleView.backgroundColor = [UIColor clearColor];
    [_BubbleView setImage:[UIImage imageNamed:@"mid_border"]];
    [self addSubview:_BubbleView];
    
    underButtble = [[UIImageView alloc]init];
    underButtble.backgroundColor = [UIColor clearColor];
    underButtble.image = [UIImage imageNamed:@"under_border"];
    [self addSubview:underButtble];
    
    _content_label = [[UILabel alloc]init];
    _content_label.backgroundColor = [UIColor clearColor];
    _content_label.font = [UIFont systemFontOfSize:HotForecastTableViewCellContentFontSize];
    _content_label.numberOfLines = 0;
    _content_label.lineBreakMode =  NSLineBreakByTruncatingTail;
    _content_label.textColor = [UIColor colorWithHexString:@"#a1a1a1"];
    [self addSubview:_content_label];
    
    _content = [[UIButton alloc]init];
    _content.backgroundColor = [UIColor clearColor];
    [_content addTarget:self action:@selector(buttonHeightChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_content];
    
    _fromHint = [[UILabel alloc]init];
    _fromHint.backgroundColor = [UIColor clearColor];
    _fromHint.font = [UIFont systemFontOfSize:HotForecastTableViewCellFromHintFontSize];
    _fromHint.text = @"来自: ";
    _fromHint.textColor = [UIColor colorWithHexString:@"#a5a5a5"];
    [self addSubview:_fromHint];
    
    _fromLabel = [[UILabel alloc]init];
    _fromLabel.font = [UIFont systemFontOfSize:HotForecastTableViewCellFromHintFontSize];
    _fromLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    _fromLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_fromLabel];
    
    _sayButton = [[UIButton alloc]init];
    _sayButton.tag = 10;
    [_sayButton setTitle:@"我想说" forState:UIControlStateNormal];
    //    sayButton setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>
    _sayButton.backgroundColor = [UIColor colorWithHexString:@"#1063c9"];
    _sayButton.layer.masksToBounds = YES;
    _sayButton.layer.cornerRadius = 3.0;
    _sayButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_sayButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sayButton];
    
    _lookButton = [[UIButton alloc]init];
    _lookButton.tag = 11;
    [_lookButton setTitle:@"我想看" forState:UIControlStateNormal];
//    _lookButton.backgroundColor = [UIColor colorWithHexString:@"#1063c9"];
    _lookButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _lookButton.tag = 1;
    _lookButton.layer.masksToBounds = YES;
    _lookButton.layer.cornerRadius = 3.0;
    [_lookButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lookButton];
}


- (void)buttonHeightChange:(UILabel*)sender
{
    _model.isShow = !_model.isShow;
    [_tableview reloadData];
    //    [self setNeedsDisplay];
}

#pragma mark 设置控件长宽
-(void)setStatus:(HotForecastModel *)model
{
    _titlelabel.frame = CGRectMake(50, 10, 215, model.titleSize.height);
    _titlelabel.text = model.title;
    
    
    if([model getContenHeight]==0){
        topBubble.frame = CGRectMake(_titlelabel.frame.origin.x-5, _titlelabel.frame.origin.y+_titlelabel.frame.size.height, _titlelabel.frame.size.width+10, 0);
        _BubbleView.frame = CGRectMake(topBubble.frame.origin.x, topBubble.frame.origin.y+topBubble.frame.size.height, topBubble.frame.size.width, 0);
        underButtble.frame = CGRectMake(_BubbleView.frame.origin.x, _BubbleView.frame.origin.y+_BubbleView.frame.size.height, _BubbleView.frame.size.width, 0);
    }else{
        topBubble.frame = CGRectMake(_titlelabel.frame.origin.x-5, _titlelabel.frame.origin.y+_titlelabel.frame.size.height, _titlelabel.frame.size.width+10, 15);
        _BubbleView.frame = CGRectMake(topBubble.frame.origin.x, topBubble.frame.origin.y+topBubble.frame.size.height, topBubble.frame.size.width, [model getContenHeight]-10);
        underButtble.frame = CGRectMake(_BubbleView.frame.origin.x, _BubbleView.frame.origin.y+_BubbleView.frame.size.height, _BubbleView.frame.size.width, 8);
    }

    
    _content.frame = CGRectMake(_BubbleView.frame.origin.x+5, _BubbleView.frame.origin.y-5, _BubbleView.frame.size.width-10,[model getContenHeight]);
    _content_label.frame = _content.frame;
    _content_label.text = model.content;
//    _content.text = model.content;
    
    _fromHint.frame = CGRectMake(underButtble.frame.origin.x, underButtble.frame.origin.y+underButtble.frame.size.height+12.5, 35,12);
    
    _fromLabel.frame = CGRectMake(_fromHint.frame.origin.x + _fromHint.frame.size.width, _fromHint.frame.origin.y, 60,12);
    _fromLabel.text = model.user;
    
    _lookButton.frame = CGRectMake(RIGHTVIEWWIGHT-BUTTONFRAME-10, _fromLabel.frame.origin.y-5, BUTTONFRAME, 22);
    
    _sayButton.frame = CGRectMake(RIGHTVIEWWIGHT-2*BUTTONFRAME-15, _fromLabel.frame.origin.y-5, BUTTONFRAME, 22);
    if (![[NSUserDefaults standardUserDefaults]boolForKey:model.ID]) {
        _lookButton.backgroundColor = [UIColor colorWithHexString:@"#1063c9"];
    }else{
        _lookButton.backgroundColor = [UIColor colorWithHexString:@"#A0A0A0"];
    }
    _model = model;
}

- (void)buttonOnClick:(UIButton*)sender
{
    if (sender.tag == 10) {
        YourSayViewController *you = [[YourSayViewController alloc]init];
        you.model = _model;
        [self.nav pushViewController:you animated:YES];
    }else{
        if (_lookButton.tag==2) {
            return;
        }
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:UUID,@"imei",_model.ID,@"mid",nil];
        [[XHRequest shareInstance]POST_Path:@"Common_SetLiterMemoCommend.ashx" params:dic completed:^(id JSON, NSString *stringData) {
            NSDictionary *jsonDict = [stringData JSONValue];
            _lookButton.tag=2;
            _lookButton.backgroundColor = [UIColor colorWithHexString:@"#A0A0A0"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:_model.ID];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadData" object:nil];
        } failed:^(NSError *error) {

        }];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
