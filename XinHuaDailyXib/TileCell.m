//
//  TileCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "TileCell.h"
#import "ALImageView.h"
@interface TileCell()
@property(nonatomic,strong)UIImageView *movie_image_view;
@property(nonatomic,strong)UILabel *visit_number_lbl;
@property(nonatomic,strong)UILabel *like_number_lbl;
@end
@implementation TileCell{
    ALImageView *alImageView;
    UILabel *title;
    UILabel *summary_label;
    Article *_article;
    UIImageView *dot_line_view;
}
@synthesize visit_number_lbl=_visit_number_lbl;
@synthesize like_number_lbl=_like_number_lbl;
@synthesize movie_image_view=_movie_image_view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bg_view=[[UIView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width-20, 250)];
        bg_view.backgroundColor=[UIColor whiteColor];
        [self addSubview:bg_view];
        alImageView = [[ALImageView alloc] initWithFrame:CGRectMake(0,0 , bg_view.bounds.size.width , 200)];
        alImageView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        alImageView.imageURL = @"";
        [bg_view addSubview:alImageView];
        title = [[UILabel alloc] initWithFrame:CGRectMake(10,200 , bg_view.bounds.size.width-20, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"";
        title.textColor = [UIColor blackColor];
        title.backgroundColor=[UIColor clearColor];
        title.font = [UIFont fontWithName:@"Arial" size:17];
        [bg_view addSubview:title];
        summary_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, bg_view.bounds.size.width-20, 30)];
        summary_label.backgroundColor = [UIColor clearColor];
        summary_label.font = [UIFont fontWithName:@"Arial" size:10];
        summary_label.numberOfLines=2;
        summary_label.backgroundColor=[UIColor clearColor];
        summary_label.textColor=[UIColor grayColor];
        [bg_view addSubview:summary_label];
        
        _movie_image_view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moviemaker.png"]];
        _movie_image_view.frame=CGRectMake(self.bounds.size.width-30, (70-16)/2, 16, 16);
        _movie_image_view.hidden=YES;
        [bg_view addSubview:_movie_image_view];
        
        _visit_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(bg_view.bounds.size.width-120, 220, 60, 30)];
        _visit_number_lbl.backgroundColor = [UIColor clearColor];
        _visit_number_lbl.font = [UIFont fontWithName:@"Arial" size:10];
        _visit_number_lbl.textColor=[UIColor grayColor];
        [bg_view addSubview:_visit_number_lbl];
        
        _like_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(bg_view.bounds.size.width-60, 220, 60, 30)];
        _like_number_lbl.backgroundColor = [UIColor clearColor];
        _like_number_lbl.font = [UIFont fontWithName:@"Arial" size:10];
        _like_number_lbl.textColor=[UIColor grayColor];
        [bg_view addSubview:_like_number_lbl];
    }
    self.backgroundColor=VC_BG_COLOR;
    return self;
}
-(Article *)article{
    return _article;
}
-(void)setArticle:(Article *)article{
    if(_article==nil||![article.article_id isEqualToString:_article.article_id]){
        _article=article;
        title.text=article.article_title;
        if(article.cover_image_url==nil&&article.thumbnail_url==nil){
            alImageView.hidden=YES;
//            title.frame=CGRectMake(0, 10, self.bounds.size.width-20, 22);
//            summary_label.frame=CGRectMake(0, 35, self.bounds.size.width-16, 35);
//            dot_line_view.frame=CGRectMake(0, 69, self.bounds.size.width, 1);
        }else{
            alImageView.hidden=NO;
//            title.frame=CGRectMake(10,200 , 320-20, 20);
//            summary_label.frame=CGRectMake(10, 220, 320-20, 20);
//            dot_line_view.frame=CGRectMake(0, 269, self.bounds.size.width, 1);
            if(article.cover_image_url==nil){
                alImageView.imageURL=article.thumbnail_url;
            }else{
                alImageView.imageURL=article.cover_image_url;
            }
        }
        summary_label.text=article.publish_date;
        _visit_number_lbl.text=[NSString stringWithFormat:@"访问量：%d",article.visit_number.integerValue+25];
        _like_number_lbl.text=[NSString stringWithFormat:@"点赞量：%d",article.like_number.integerValue+5];
        if(_article.video_url!=nil){
            _movie_image_view.hidden=NO;
        }else{
            _movie_image_view.hidden=YES;
        }
    }
}
@end
