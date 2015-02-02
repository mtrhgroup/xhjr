//
//  ListCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "ListCell.h"
#import "ALImageView.h"
@interface ListCell()
@property(nonatomic,strong)UIImageView *movie_image_view;
@property(nonatomic,strong)UILabel *visit_number_lbl;
@property(nonatomic,strong)UILabel *like_number_lbl;
@end

@implementation ListCell{
    ALImageView *thumbnail_view;
    UILabel *title_label;
    UILabel *summary_label;
    Article *_article;
}
@synthesize movie_image_view=_movie_image_view;
@synthesize visit_number_lbl=_visit_number_lbl;
@synthesize like_number_lbl=_like_number_lbl;
- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        thumbnail_view = [[ALImageView alloc] initWithFrame:CGRectMake(8, 8, 72, 54)];
        thumbnail_view.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:thumbnail_view];
        
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(90, 8, 222, 30)];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont fontWithName:@"Arial" size:15];
        title_label.numberOfLines=1;
        [[self contentView] addSubview:title_label];
        
        summary_label = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 222, 40)];
        summary_label.backgroundColor = [UIColor clearColor];
        summary_label.font = [UIFont fontWithName:@"Arial" size:10];
        summary_label.textColor=[UIColor grayColor];
        summary_label.numberOfLines=2;
        [[self contentView] addSubview:summary_label];
        
        _movie_image_view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moviemaker.png"]];
        _movie_image_view.frame=CGRectMake(self.bounds.size.width-30, (70-16)/2, 16, 16);
        _movie_image_view.hidden=YES;
        [[self contentView] addSubview:_movie_image_view];

        _visit_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-120, 40, 60, 30)];
        _visit_number_lbl.backgroundColor = [UIColor clearColor];
        _visit_number_lbl.font = [UIFont fontWithName:@"Arial" size:10];
        _visit_number_lbl.textColor=[UIColor colorWithRed:0x18/255.0 green:0x74/255.0 blue:0xCD/255.0 alpha:0.6];
        [[self contentView] addSubview:_visit_number_lbl];
        
        _like_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-60, 40, 60, 30)];
        _like_number_lbl.backgroundColor = [UIColor clearColor];
        _like_number_lbl.font = [UIFont fontWithName:@"Arial" size:10];
        _like_number_lbl.textColor=[UIColor colorWithRed:0x18/255.0 green:0x74/255.0 blue:0xCD/255.0 alpha:0.6];
        [[self contentView] addSubview:_like_number_lbl];
        
        
        
    }
    UIView *line_view=[[UIView alloc] initWithFrame:CGRectMake(0, 69, self.bounds.size.width, 0.5)];
    line_view.backgroundColor=[UIColor lightGrayColor];
    line_view.alpha=0.2;
    [self addSubview:line_view];
    return self;
}
-(Article *)artilce{
    return _article;
}
-(void)setArticle:(Article *)article{
    if(_article==nil||![article.article_id isEqualToString:_article.article_id]){
        _article=article;
        if(article.thumbnail_url==nil||[article.thumbnail_url isEqualToString:@""]){
            title_label.frame=CGRectMake(8, 5, self.bounds.size.width-16, 20);
            summary_label.frame=CGRectMake(8, 22, self.bounds.size.width-16, 30);
            thumbnail_view.imageURL=@"";
            thumbnail_view.hidden=YES;
        }else{
            thumbnail_view.hidden=NO;
            thumbnail_view.imageURL=article.thumbnail_url;
            title_label.frame=CGRectMake(90, 6, 222, 20);
            summary_label.frame=CGRectMake(90, 22, 222, 30);
        }
        title_label.text=article.article_title;
        summary_label.text=article.summary;
        _visit_number_lbl.text=[NSString stringWithFormat:@"访问量：%d",article.visit_number.integerValue+100];
        _like_number_lbl.text=[NSString stringWithFormat:@"点赞量：%d",article.like_number.integerValue+10];
        if(_article.video_url!=nil){
            _movie_image_view.hidden=NO;
        }else{
            _movie_image_view.hidden=YES;
        }
        
    }
    if(article.is_read){
        title_label.textColor=[UIColor grayColor];
    }
}

@end
