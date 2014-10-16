//
//  KidsPopupMenuView.m
//  kidsgarden
//
//  Created by apple on 14/6/25.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "PopupMenuView.h"

@implementation PopupMenuView{
    UIButton * favor_yes_btn;
    UIButton * favor_no_btn;
    UIControl * trs_ctrl;
    UIView *botton_bar;
    BOOL is_favor;
    int offset;
    
}
@synthesize delegate=_delegate;
@synthesize favor_status=_favor_status;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(lessiOS7){
            offset=44;
        }else{
            offset=0;
        }
        trs_ctrl = [[UIControl alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, self.bounds.size.height)];
        [trs_ctrl  addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:trs_ctrl];
        
        
        botton_bar = [[UIView alloc] initWithFrame:CGRectMake(205, 30-offset, 114, 150)];
        botton_bar.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.0];
        [self addSubview:botton_bar];
        
        favor_no_btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 70, 150,40)];
        [favor_no_btn  addTarget:self action:@selector(favor) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *favor_no_pic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_unfavor.png"]];
        favor_no_pic.frame=CGRectMake(0, 13, 20, 20);
        [favor_no_btn addSubview:favor_no_pic];
        UILabel *favor_no_text=[[UILabel alloc] initWithFrame:CGRectMake(40, 15, 56, 14)];
        favor_no_text.text=@"收藏";
        favor_no_text.textColor=[UIColor blackColor];
        favor_no_text.backgroundColor=[UIColor clearColor];
        [favor_no_btn addSubview:favor_no_text];
        favor_no_btn.showsTouchWhenHighlighted=YES;
        [botton_bar addSubview:favor_no_btn];
        
        
        
        favor_yes_btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 70, 150,40)];
        [favor_yes_btn  addTarget:self action:@selector(unfavor) forControlEvents:UIControlEventTouchUpInside];
        favor_yes_btn.hidden=YES;
        UIImageView *favor_yes_pic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_favor.png"]];
        favor_yes_pic.frame=CGRectMake(0, 13, 20, 20);
        [favor_yes_btn addSubview:favor_yes_pic];
        UILabel *favor_yes_text=[[UILabel alloc] initWithFrame:CGRectMake(40, 15, 56, 14)];
        favor_yes_text.text=@"收藏";
        favor_yes_text.backgroundColor=[UIColor clearColor];
        favor_yes_text.textColor=[UIColor blackColor];
        [favor_yes_btn addSubview:favor_yes_text];
        favor_yes_btn.showsTouchWhenHighlighted=YES;
        [botton_bar addSubview:favor_yes_btn];
        
        UIButton* shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 150,40)];
        [shareBtn  addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *share_pic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_share.png"]];
        share_pic.frame=CGRectMake(0, 13, 20, 20);
        [shareBtn addSubview:share_pic];
        UILabel *share_txt=[[UILabel alloc] initWithFrame:CGRectMake(40, 15, 56, 14)];
        share_txt.text=@"分享";
        share_txt.textColor=[UIColor blackColor];
        share_txt.backgroundColor=[UIColor clearColor];
        [shareBtn addSubview:share_txt];
        shareBtn.showsTouchWhenHighlighted=YES;
        [botton_bar addSubview:shareBtn];
        
        UIView *segline2=[[UIView alloc] initWithFrame:CGRectMake(5, 69, 103, 0.5)];
        segline2.backgroundColor=[UIColor grayColor];
        [botton_bar addSubview:segline2];
        
        UIView *segline3=[[UIView alloc] initWithFrame:CGRectMake(5, 109, 103, 0.5)];
        segline3.backgroundColor=[UIColor lightGrayColor];
        [botton_bar addSubview:segline3];
        
        UIButton* fontBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 110, 150,40)];
        [fontBtn  addTarget:self action:@selector(font) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *font_pic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_font.png"]];
        font_pic.frame=CGRectMake(0, 13, 25, 17);
        [fontBtn addSubview:font_pic];
        UILabel *font_txt=[[UILabel alloc] initWithFrame:CGRectMake(40, 15, 56, 14)];
        font_txt.text=@"字体";
        font_txt.textColor=[UIColor blackColor];
        font_txt.backgroundColor=[UIColor clearColor];
        [fontBtn addSubview:font_txt];
        fontBtn.showsTouchWhenHighlighted=YES;
        [botton_bar addSubview:fontBtn];
        self.hidden=YES;
    }
    return self;
}
-(void)show{
    if(_favor_status==YES){
        favor_yes_btn.hidden=NO;
        favor_no_btn.hidden=YES;
    }else{
        favor_yes_btn.hidden=YES;
        favor_no_btn.hidden=NO;
    }
    self.hidden=NO;
}
-(void)hide{
    self.hidden=YES;
}

-(void)favor{
    [self hide];
    _favor_status=YES;
    favor_yes_btn.hidden=NO;
    favor_no_btn.hidden=YES;
    [self.delegate favor];
}
-(void)unfavor{
    [self hide];
    _favor_status=NO;
    favor_yes_btn.hidden=YES;
    favor_no_btn.hidden=NO;
    [self.delegate unfavor];
}
-(void)share{
    [self hide];
    [self.delegate share];
}
-(void)font{
    [self hide];
    [self.delegate font];
}
@end
