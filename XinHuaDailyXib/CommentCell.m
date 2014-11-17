//
//  CommentCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/17.
//
//

#import "CommentCell.h"

@implementation CommentCell{
    UILabel *source_lbl;
    UILabel *content_lbl;
    UILabel *time_lbl;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        source_lbl = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 320-20, 20)];
        source_lbl.backgroundColor = [UIColor clearColor];
        source_lbl.text = @"";
        source_lbl.textColor = [UIColor blackColor];
        source_lbl.font = [UIFont fontWithName:@"Arial" size:15];
        [[self contentView] addSubview:source_lbl];
        time_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-100, 0, 320-20, 20)];
        time_lbl.backgroundColor = [UIColor clearColor];
        time_lbl.font = [UIFont fontWithName:@"Arial" size:13];
        time_lbl.numberOfLines=2;
        time_lbl.textColor=[UIColor grayColor];
        [[self contentView] addSubview:time_lbl];
        content_lbl = [[UILabel alloc] initWithFrame:CGRectMake(10,30, 320-20, 20)];
        content_lbl.backgroundColor = [UIColor clearColor];
        content_lbl.text = @"";
        content_lbl.textColor = [UIColor blackColor];
        content_lbl.font = [UIFont fontWithName:@"Arial" size:15];
        [[self contentView] addSubview:content_lbl];

    }
    
    self.selectionStyle =UITableViewCellSelectionStyleNone;
    return self;
}
-(void)setComment:(Comment *)comment{
    if(comment.comment_source.length>11){
    NSMutableString *phone_number=[NSMutableString stringWithString:[comment.comment_source substringWithRange:NSMakeRange(comment.comment_source.length-11, 11)]];
    [phone_number replaceCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
        source_lbl.text=phone_number;
    }
    content_lbl.text=comment.comment_content;
    time_lbl.text=comment.comment_time;
}
@end
