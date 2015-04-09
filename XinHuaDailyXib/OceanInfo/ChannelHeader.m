//
//  GridHeader.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "ChannelHeader.h"
#import "ALImageView.h"
#import "Util.h"
@interface ChannelHeader()
@property(nonatomic,strong)UILabel *comment_number_lbl;
@property(nonatomic,strong)UILabel *like_number_lbl;
@property(nonatomic,strong)UILabel *channel_name_lbl;
@property(nonatomic,strong)UIImageView *like_icon;
@property(nonatomic,strong)UIImageView *comment_icon;
@property(nonatomic,strong)UIView *line_view;
@end
@implementation ChannelHeader{
    ALImageView *alImageView;
    UILabel *label;
    UILabel *summary_lbl;
    UIButton *btn;
    Article *_article;
}
@synthesize comment_icon=_comment_icon;
@synthesize comment_number_lbl=_comment_number_lbl;
@synthesize like_icon=_like_icon;
@synthesize like_number_lbl=_like_number_lbl;
@synthesize channel_name_lbl=_channel_name_lbl;
@synthesize line_view=_line_view;
- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {

        
        alImageView = [[ALImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width*(9.0/16))];
        alImageView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        alImageView.imageURL = @"";
        [self  addSubview:alImageView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(2,alImageView.frame.size.height+5, frameRect.size.width-4, 60)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor blackColor];
        label.numberOfLines=3;
        label.font = [UIFont boldSystemFontOfSize:22];
        [self addSubview:label];

        alImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArticle)];
        [self addGestureRecognizer:singleTap];
        
        _channel_name_lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, label.frame.origin.y+label.frame.size.height+5, 150, 17)];
        _channel_name_lbl.backgroundColor = [UIColor clearColor];
        _channel_name_lbl.font = [UIFont systemFontOfSize:12];
        _channel_name_lbl.textColor=[UIColor grayColor];
        [self addSubview:_channel_name_lbl];

        
        _comment_icon=[[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-18, label.frame.origin.y+label.frame.size.height+5, 17, 17)];
        _comment_icon.image=[UIImage imageNamed:@"button_review.png"];
        [self addSubview:_comment_icon];
        
        _comment_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-43, label.frame.origin.y+label.frame.size.height+5, 25, 17)];
        _comment_number_lbl.backgroundColor = [UIColor clearColor];
        _comment_number_lbl.textAlignment=NSTextAlignmentRight;
        _comment_number_lbl.font = [UIFont fontWithName:@"Arial" size:12];
        _comment_number_lbl.textColor=[UIColor grayColor];
        [self addSubview:_comment_number_lbl];
        
        _like_icon=[[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-60, label.frame.origin.y+label.frame.size.height+5, 17, 17)];
        _like_icon.image=[UIImage imageNamed:@"button_wonderful.png"];
        [self addSubview:_like_icon];
        
        _like_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-85, label.frame.origin.y+label.frame.size.height+5, 25, 17)];
        _like_number_lbl.backgroundColor = [UIColor clearColor];
        _like_number_lbl.textAlignment=NSTextAlignmentRight;
        _like_number_lbl.font = [UIFont fontWithName:@"Arial" size:12];
        _like_number_lbl.textColor=[UIColor grayColor];
        [self addSubview:_like_number_lbl];
    }
    self.line_view = [[UIView alloc]initWithFrame:CGRectMake(0, _channel_name_lbl.frame.origin.y+_channel_name_lbl.frame.size.height+4, self.bounds.size.width, 1)];
    self.line_view.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:self.line_view];
    return self;
}
-(void)setArticle:(Article *)article{
        _channel_name_lbl.hidden=NO;
        _comment_number_lbl.hidden=NO;
        _comment_icon.hidden=NO;
        _like_number_lbl.hidden=NO;
        _like_icon.hidden=NO;
        if(_article==nil||![article.article_id isEqualToString:_article.article_id]){
            _article=article;
            label.text=article.article_title;
            if(article.cover_image_url==nil)
                alImageView.imageURL=article.thumbnail_url;
            else
                alImageView.imageURL=article.cover_image_url;
            if(article.is_topic_channel){
                _channel_name_lbl.text=@"";
            }else{
                if(self.is_home_header){
                    _channel_name_lbl.text=[NSString stringWithFormat:@"%@/%@",article.channel_name,[Util wrapDateString:article.publish_date]];
                }else{
                    _channel_name_lbl.text=[Util wrapDateString:article.publish_date];
                }
            }
            
            _comment_number_lbl.text=[NSString stringWithFormat:@"%d",article.comments_number.integerValue];
            _like_number_lbl.text=[NSString stringWithFormat:@"%d",article.like_number.integerValue];
            self.line_view.frame=CGRectMake(0, _channel_name_lbl.frame.origin.y+_channel_name_lbl.frame.size.height+4, self.bounds.size.width, 1);
        }
        if(article.is_topic_channel){
            _article=article;
            alImageView.imageURL=article.thumbnail_url;
            _channel_name_lbl.hidden=YES;
            _comment_number_lbl.hidden=YES;
            _comment_icon.hidden=YES;
            _like_number_lbl.hidden=YES;
            _like_icon.hidden=YES;
            self.line_view.frame=CGRectMake(0, label.frame.origin.y+label.frame.size.height, self.bounds.size.width, 1);
        }
}
-(void)openArticle{
    if(_article!=nil&&[self.delegate respondsToSelector:@selector(headerClicked:)]){
        [self.delegate headerClicked:_article];
    }
}
-(CGFloat)preferHeight{
    return self.line_view.frame.origin.y+1;
   
}

@end
