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

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title_lbl = [[UILabel alloc] initWithFrame:CGRectMake(10,5 , 320-20, 34)];
        title_lbl.backgroundColor = [UIColor clearColor];
        title_lbl.text = @"";
        title_lbl.textColor = [UIColor blackColor];
        title_lbl.font = [UIFont fontWithName:@"Arial" size:17];
        title_lbl.numberOfLines=2;
        [[self contentView] addSubview:title_lbl];
    }
    return self;
}
-(void)setArticle:(Article *)article{
    title_lbl.text=article.article_title;
}

@end
