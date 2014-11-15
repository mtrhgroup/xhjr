//
//  TileCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "TileCell.h"
#import "ALImageView.h"
@implementation TileCell{
    ALImageView *alImageView;
    UILabel *label;
    UILabel *summary_label;
    Article *_article;
    UIImageView *dot_line_view;
    UILabel *keywords_label;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        keywords_label = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 320-20, 20)];
        keywords_label.backgroundColor = [UIColor clearColor];
        keywords_label.text = @"";
        keywords_label.textColor = [UIColor blackColor];
        keywords_label.font = [UIFont fontWithName:@"Arial" size:15];
        [[self contentView] addSubview:keywords_label];
        alImageView = [[ALImageView alloc] initWithFrame:CGRectMake(10,20 , 320-20 , 180)];
        alImageView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        alImageView.imageURL = @"";
        [[self contentView] addSubview:alImageView];
        label = [[UILabel alloc] initWithFrame:CGRectMake(10,200 , 320-20, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Arial" size:15];
        [[self contentView] addSubview:label];
        summary_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 320-20, 20)];
        summary_label.backgroundColor = [UIColor clearColor];
        summary_label.font = [UIFont fontWithName:@"Arial" size:13];
        summary_label.numberOfLines=2;
        summary_label.textColor=[UIColor grayColor];
        [[self contentView] addSubview:summary_label];
    }

    self.selectionStyle =UITableViewCellSelectionStyleNone;
    return self;
}
-(Article *)article{
    return _article;
}
-(void)setArticle:(Article *)article{
    if(_article==nil||![_article.article_id isEqualToString:article.article_id]){
        _article=article;
        label.text=article.article_title;
        if(article.key_words.length!=0){
            NSArray *keywords= [article.key_words componentsSeparatedByString:NSLocalizedString(@",", nil)];
            keywords_label.text=[NSString stringWithFormat:@"[%@]",[keywords componentsJoinedByString:@"]["]];
        }
        if(article.cover_image_url==nil&&article.thumbnail_url==nil){
            alImageView.hidden=YES;
            label.frame=CGRectMake(8, 8, self.bounds.size.width-16, 22);
            summary_label.frame=CGRectMake(8, 35, self.bounds.size.width-16, 35);
            dot_line_view.frame=CGRectMake(0, 69, self.bounds.size.width, 1);
        }else{
            alImageView.hidden=NO;
            label.frame=CGRectMake(10,200 , 320-20, 20);
            summary_label.frame=CGRectMake(10, 220, 320-20, 20);
            dot_line_view.frame=CGRectMake(0, 269, self.bounds.size.width, 1);
            if(article.cover_image_url==nil){
                alImageView.imageURL=article.thumbnail_url;
            }else{
                alImageView.imageURL=article.cover_image_url;
            }
        }
        if(article.summary==nil||[article.summary isEqualToString:@""]){
            summary_label.text=article.publish_date;
        }else{
            summary_label.text=article.summary;
        }
    }
}
@end
