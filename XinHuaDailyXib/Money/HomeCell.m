//
//  ListCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "HomeCell.h"
#import "ALImageView.h"
#import "Util.h"
@interface HomeCell()
@property(nonatomic,strong)UIImageView *movie_image_view;
@property(nonatomic,strong)UILabel *comment_number_lbl;
@property(nonatomic,strong)UILabel *like_number_lbl;
@property(nonatomic,strong)UILabel *channel_name_lbl;
@property(nonatomic,strong)UILabel *summary_lbl;
@property(nonatomic,strong)UIImageView *like_icon;
@property(nonatomic,strong)UIImageView *comment_icon;
@end

@implementation HomeCell{
    ALImageView *thumbnail_view;
    UILabel *title_label;
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
        thumbnail_view = [[ALImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-2-100, 40, 100, 75)];
        thumbnail_view.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:thumbnail_view];
        
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, self.frame.size.width-4, 30)];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont systemFontOfSize:22];
        title_label.numberOfLines=3;
        [[self contentView] addSubview:title_label];
        
        _channel_name_lbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 90, 222, 20)];
        _channel_name_lbl.backgroundColor = [UIColor clearColor];
        _channel_name_lbl.font = [UIFont systemFontOfSize:15];
        _channel_name_lbl.textColor=[UIColor grayColor];
        [[self contentView] addSubview:_channel_name_lbl];
        
        
        summary_label = [[UILabel alloc] initWithFrame:CGRectMake(2, 30, self.frame.size.width-100-6, 60)];
        summary_label.backgroundColor = [UIColor clearColor];
        summary_label.font = [UIFont systemFontOfSize:17];
        summary_label.textColor=[UIColor grayColor];
        summary_label.numberOfLines=2;
        [[self contentView] addSubview:summary_label];
        
        _movie_image_view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moviemaker.png"]];
        _movie_image_view.frame=CGRectMake(100/2-12, 75/2-12, 24, 24);
        _movie_image_view.alpha=0.5;
        _movie_image_view.hidden=YES;
        [thumbnail_view addSubview:_movie_image_view];
        
    }
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 119, self.frame.size.width, 1)];
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
        if(article.thumbnail_url==nil||[article.thumbnail_url isEqualToString:@""]){
            thumbnail_view.imageURL=nil;
            thumbnail_view.hidden=YES;
            summary_label.frame=CGRectMake(2, 30, cell_width-4, 60);
        }else{
            thumbnail_view.hidden=NO;
            thumbnail_view.imageURL=article.thumbnail_url;
            summary_label.frame=CGRectMake(2, 30, self.frame.size.width-100-6, 60);
        }
        title_label.text=article.article_title;
        summary_label.text=article.summary;
        _comment_number_lbl.text=[NSString stringWithFormat:@"%d",article.comments_number.integerValue];
        _like_number_lbl.text=[NSString stringWithFormat:@"%d",article.like_number.integerValue];
        if(_article.video_url!=nil&&article.thumbnail_url!=nil){
            _movie_image_view.hidden=NO;
        }else{
            _movie_image_view.hidden=YES;
        }
        
    }
    if(self.is_on_home){
        _channel_name_lbl.text=[NSString stringWithFormat:@"%@/%@",article.channel_name,[Util wrapDateString:article.publish_date]];
    }else{
        _channel_name_lbl.text=[Util wrapDateString:article.publish_date];
    }
    if(article.is_read){
        title_label.textColor=[UIColor grayColor];
    }
}
+(CGFloat)preferHeight{
    return 120;
}


@end
