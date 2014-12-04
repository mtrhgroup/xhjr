//
//  AttentionTableViewCell.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/18.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//
#define BUTTONFRAME 60
//字体大小
#define HotForecastTableViewCellTitleFontSize 18
#define HotForecastTableViewCellContentFontSize 14
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
    UILabel *_content;
    UIImageView*_BubbleView;
    UILabel *_fromLabel;
    UILabel *_fromHint;
    UIButton *_lookButton;
    UIButton *_sayButton;
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
    [self addSubview:_titlelabel];
    
    UIImage * img = [UIImage imageNamed:@"balloon_back_left"];
    img=[img stretchableImageWithLeftCapWidth:35 topCapHeight:24];
    _BubbleView = [[UIImageView alloc]init];
    _BubbleView.backgroundColor = [UIColor clearColor];
    [_BubbleView setImage:img];
    [self addSubview:_BubbleView];
    
    _content = [[UILabel alloc]init];
    _content.backgroundColor = [UIColor clearColor];
    _content.font = [UIFont systemFontOfSize:HotForecastTableViewCellContentFontSize];
    _content.numberOfLines = 0;
    _content.lineBreakMode =  NSLineBreakByCharWrapping;
    _content.textColor = [UIColor colorWithHexString:@"#a1a1a1"];
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
    //    sayButton setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>
    _lookButton.backgroundColor = [UIColor colorWithHexString:@"#1063c9"];
    _lookButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _lookButton.layer.masksToBounds = YES;
    _lookButton.layer.cornerRadius = 3.0;
    [_lookButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lookButton];
}

#pragma mark 设置控件长宽
-(void)setStatus:(HotForecastModel *)model andHeight:(CGFloat)contentHeight
{
    _titlelabel.frame = CGRectMake(50, 10, 280-75, 20);
    _titlelabel.text = model.title;
    
    _BubbleView.frame = CGRectMake(_titlelabel.frame.origin.x-5, _titlelabel.frame.origin.y+_titlelabel.frame.size.height+1, 220, contentHeight + 20);
    
    _content.frame = CGRectMake(_BubbleView.frame.origin.x+10, _BubbleView.frame.origin.y+5, _BubbleView.frame.size.width-10,_BubbleView.frame.size.height-10);
    _content.text = model.content;
    
    _fromHint.frame = CGRectMake(_BubbleView.frame.origin.x, _BubbleView.frame.origin.y+_BubbleView.frame.size.height+10, 35,12);
    
    _fromLabel.frame = CGRectMake(_fromHint.frame.origin.x + _fromHint.frame.size.width, _fromHint.frame.origin.y, 60,12);
    _fromLabel.text = model.user;
    
    _lookButton.frame = CGRectMake(280-BUTTONFRAME-5, _fromLabel.frame.origin.y-3, BUTTONFRAME, 22);
    
    _sayButton.frame = CGRectMake(280-2*BUTTONFRAME-15, _fromLabel.frame.origin.y-3, BUTTONFRAME, 22);
    _model = model;
}

- (void)buttonOnClick:(UIButton*)sender
{
    if (sender.tag == 10) {
//        [self.delegate sayButtonClickAndPageNum:2 andCellNum:self];
        YourSayViewController *you = [[YourSayViewController alloc]init];
        you.model = _model;
        [self.nav pushViewController:you animated:YES];
    }else{
        if (sender.hidden) {
            return;
        }
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:UUID,@"imei",_model.ID,@"mid",nil];
        [[XHRequest shareInstance]POST_Path:@"Common_SetLiterMemoCommend.ashx" params:dic completed:^(id JSON, NSString *stringData) {
            NSDictionary *jsonDict = [stringData JSONValue];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:[jsonDict[@"error_title"]URLDecodedString] message:[jsonDict[@"error"]URLDecodedString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alter.delegate = self;
            [alter show];
            sender.hidden = YES;
        } failed:^(NSError *error) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
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
