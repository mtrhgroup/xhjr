//
//  ListCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "ListCell.h"
#import "ALImageView.h"
#import "Util.h"
#import "YLLabel.h"
@interface ListCell()
@property(nonatomic,strong)UIImageView *movie_image_view;
@property(nonatomic,strong)UILabel *comment_number_lbl;
@property(nonatomic,strong)UILabel *like_number_lbl;
@property(nonatomic,strong)UILabel *channel_name_lbl;
@property(nonatomic,strong)UIImageView *like_icon;
@property(nonatomic,strong)UIImageView *comment_icon;
@end

@implementation ListCell{
    ALImageView *thumbnail_view;
    YLLabel *title_label;
    UILabel *summary_label;
    Article *_article;
    float cell_width;
}
@synthesize movie_image_view=_movie_image_view;
@synthesize comment_number_lbl=_comment_number_lbl;
@synthesize like_number_lbl=_like_number_lbl;
@synthesize channel_name_lbl=_channel_name_lbl;
@synthesize comment_icon=_comment_icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    cell_width=[[UIScreen mainScreen] applicationFrame].size.width;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        thumbnail_view = [[ALImageView alloc] initWithFrame:CGRectMake(2, 8, 100, 75)];
        thumbnail_view.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:thumbnail_view];
        
        title_label = [[YLLabel alloc] initWithFrame:CGRectMake(90, 8, cell_width-90-4, 70)];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont systemFontOfSize:18];
        [[self contentView] addSubview:title_label];
        
        
        summary_label = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 222, 17)];
        summary_label.backgroundColor = [UIColor clearColor];
        summary_label.font = [UIFont systemFontOfSize:12];
        summary_label.textColor=[UIColor grayColor];
        [[self contentView] addSubview:summary_label];
        
        _movie_image_view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moviemaker.png"]];
        _movie_image_view.frame=CGRectMake(2+100/2-12, 8+75/2-12, 24, 24);
        _movie_image_view.hidden=YES;
        _movie_image_view.alpha=0.5;
        [[self contentView] addSubview:_movie_image_view];
        
        _comment_icon=[[UIImageView alloc] initWithFrame:CGRectMake(cell_width-30, 70, 17, 17)];
        _comment_icon.image=[UIImage imageNamed:@"button_review.png"];
        [self.contentView addSubview:_comment_icon];
        
        _comment_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(cell_width-60, 70, 30, 17)];
        _comment_number_lbl.backgroundColor = [UIColor clearColor];
        _comment_number_lbl.textAlignment=NSTextAlignmentRight;
        _comment_number_lbl.font = [UIFont fontWithName:@"Arial" size:12];
        _comment_number_lbl.textColor=[UIColor grayColor];
        [[self contentView] addSubview:_comment_number_lbl];
        
        _like_icon=[[UIImageView alloc] initWithFrame:CGRectMake(cell_width-75, 70, 17, 17)];
        _like_icon.image=[UIImage imageNamed:@"button_wonderful.png"];
        [self.contentView addSubview:_like_icon];
        
        _like_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(cell_width-105, 70, 30, 17)];
        _like_number_lbl.backgroundColor = [UIColor clearColor];
        _like_number_lbl.textAlignment=NSTextAlignmentRight;
        _like_number_lbl.font = [UIFont fontWithName:@"Arial" size:12];
        _like_number_lbl.textColor=[UIColor grayColor];
        [[self contentView] addSubview:_like_number_lbl];
    }
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 94, cell_width, 1)];
    line_view.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:line_view];
    return self;
}
-(Article *)artilce{
    return _article;
}
-(void)setArticle:(Article *)article{
    if(_article==nil||![article.article_id isEqualToString:_article.article_id]){
        _article=article;
        CGSize title_size;
        if(article.thumbnail_url==nil||[article.thumbnail_url isEqualToString:@""]){
            title_size=[article.article_title sizeWithFont:title_label.font constrainedToSize:CGSizeMake(cell_width-4, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            title_label.frame=CGRectMake(2, 5+(65-title_size.height)/2, cell_width-4, title_size.height+2);
            summary_label.frame=CGRectMake(8, 70, cell_width-16, 17);
            thumbnail_view.imageURL=nil;
            thumbnail_view.hidden=YES;
        }else{
            thumbnail_view.hidden=NO;
            thumbnail_view.imageURL=article.thumbnail_url;
            title_size=[article.article_title sizeWithFont:title_label.font constrainedToSize:CGSizeMake(cell_width-106-2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            title_label.frame=CGRectMake(106, 5+(65-title_size.height)/2, cell_width-106-2, title_size.height+2);
            summary_label.frame=CGRectMake(106, 70, 150, 17);
        }
        title_label.text=article.article_title;
        _comment_number_lbl.text=[NSString stringWithFormat:@"%d",article.comments_number.integerValue];
        _like_number_lbl.text=[NSString stringWithFormat:@"%d",article.like_number.integerValue];
        if(_article.video_url!=nil&&article.thumbnail_url!=nil){
            _movie_image_view.hidden=NO;
        }else{
            _movie_image_view.hidden=YES;
        }
        
    }
    summary_label.text=[Util wrapDateString:article.publish_date];
    if(article.is_read){
        title_label.textColor=[UIColor grayColor];
    }
}
+(CGFloat)preferHeight{
    return 95;
}

@end
