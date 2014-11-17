//
//  CollectorCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "CollectorCell.h"

@implementation CollectorCell{
    UILabel *title_lbl;
    UIImageView *del_icon;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        del_icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_del_default.png"]];
        del_icon.frame=CGRectMake(10, 10, 20, 20);
        [[self contentView] addSubview:del_icon];
        title_lbl = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 320-20, 20)];
        title_lbl.backgroundColor = [UIColor clearColor];
        title_lbl.text = @"";
        title_lbl.textColor = [UIColor blackColor];
        title_lbl.font = [UIFont fontWithName:@"Arial" size:15];
        [[self contentView] addSubview:title_lbl];
    }
    return self;
}
-(void)setArticle:(Article *)article{
    title_lbl.text=article.article_title;
}
-(void)setIs_editable:(BOOL)is_editable{
    if(is_editable){
        del_icon.hidden=NO;
        title_lbl.frame=CGRectMake(40, 0, 320-20, 20);
    }else{
        del_icon.hidden=YES;
        title_lbl.frame=CGRectMake(10, 0, 320-20, 20);
    }
}
@end
