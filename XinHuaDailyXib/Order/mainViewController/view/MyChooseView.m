//
//  MyChooseView.m
//  YourOrder
//
//  Created by 胡世骞 on 14/11/19.
//  Copyright (c) 2014年 cn.XinHuaShe. All rights reserved.
//

#import "MyChooseView.h"
#import "UIColor+Hex.h"
#import "XHRequest.h"
#import "NSString+SBJSON.h"
#import "Deviceinfo.h"

@interface MyChooseView ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSString *titleString;
    NSString *contentString;
    UILabel *contentHint;
    UITextField *titleTextField;
    UITextView *contentTextView;
}
@end
@implementation MyChooseView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView
{
    UIControl *_back = [[UIControl alloc] initWithFrame:self.frame];
    _back.backgroundColor = [UIColor clearColor];
    [self addSubview:_back];
    [_back addTarget:self action:@selector(backgroundTap) forControlEvents:UIControlEventTouchDown];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 50)];
    titleView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    titleView.layer.cornerRadius = 5;
    [self addSubview:titleView];
    
    titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, titleView.frame.size.width-20, 30)];
    titleTextField.placeholder = @"标题";
    titleTextField.backgroundColor = [UIColor clearColor];
    titleTextField.font = [UIFont systemFontOfSize:15];
    titleTextField.delegate = self;
    //    oldPswTF.tag = TEXTFIELDTAG;
    [titleView addSubview:titleTextField];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10,titleView.frame.origin.y+titleView.frame.size.height+10, self.frame.size.width-20, 200)];
    contentView.layer.cornerRadius = 5;
    contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:contentView];
    
    contentHint = [[UILabel alloc]initWithFrame:CGRectMake(15, 15
                                                           , 200, 15)];
    contentHint.backgroundColor = [UIColor clearColor];
    contentHint.font = [UIFont systemFontOfSize:15];
    contentHint.textColor = [UIColor colorWithHexString:@"#c7c5d0"];
    contentHint.text = @"请输入正文";
    [contentView addSubview:contentHint];
    
    contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10,5, contentView.frame.size.width-10, contentView.frame.size.height-20)];
    contentTextView.delegate = self;
    contentTextView.backgroundColor = [UIColor clearColor];
//    contentTextView.p
    contentTextView.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:contentTextView];
    
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(10, contentView.frame.origin.y+contentView.frame.size.height+10, self.frame.size.width-20, 45)];
    sendButton.backgroundColor = [UIColor colorWithHexString:@"#1063c9"];
    sendButton.layer.cornerRadius = 5;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
}

- (void)backgroundTap
{
    [self endEditing:YES];
}

- (void)buttonClick:(UIButton*)sender
{
    [self endEditing:YES];
    NSString *requestString = [NSString stringWithFormat:@"Common_SetLiterMemo.ashx"];
    //AppDelegate.user_defaults
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:[DeviceInfo udid],@"imei", APPID,@"appid",titleString,@"title",contentString,@"content",AppDelegate.user_defaults.sn,@"sn",nil];
    
    [[XHRequest shareInstance]POST_Path:requestString params:postDic completed:^(id JSON, NSString *stringData) {
        titleTextField.text = @"";
        contentTextView.text = @"";
        contentHint.hidden = NO;
        [self.delegate sendSuccess];
    } failed:^(NSError *error) {
    }];
}

#pragma -
#pragma UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    titleString = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

#pragma -
#pragma UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        contentHint.text = @"请填写正文内容...";
    }else{
        contentHint.hidden = YES;
    }
}

//隐藏键盘，实现UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [self endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    contentString = textView.text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
