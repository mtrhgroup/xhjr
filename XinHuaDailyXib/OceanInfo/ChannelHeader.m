//
//  GridHeader.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "ChannelHeader.h"
#import "ALImageView.h"
@interface ChannelHeader()
@property(nonatomic,strong)UILabel *comment_number_lbl;
@property(nonatomic,strong)UILabel *like_number_lbl;
@property(nonatomic,strong)UILabel *channel_name_lbl;
@property(nonatomic,strong)UIImageView *like_icon;
@property(nonatomic,strong)UIImageView *comment_icon;
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

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(8,210, frameRect.size.width-16, 60)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor blackColor];
        label.numberOfLines=2;
        label.font = [UIFont boldSystemFontOfSize:22];
        [self addSubview:label];
        
        alImageView = [[ALImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 202)];
        alImageView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        alImageView.imageURL = @"";
        [self  addSubview:alImageView];

        alImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArticle)];
        [self addGestureRecognizer:singleTap];
        
        _channel_name_lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 270, 222, 22)];
        _channel_name_lbl.backgroundColor = [UIColor clearColor];
        _channel_name_lbl.font = [UIFont systemFontOfSize:15];
        _channel_name_lbl.textColor=[UIColor grayColor];
        [self addSubview:_channel_name_lbl];

        
        _comment_icon=[[UIImageView alloc] initWithFrame:CGRectMake(290, 270, 22, 22)];
        _comment_icon.image=[UIImage imageNamed:@"button_review.png"];
        [self addSubview:_comment_icon];
        
        _comment_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(260, 270, 30, 22)];
        _comment_number_lbl.backgroundColor = [UIColor clearColor];
        _comment_number_lbl.textAlignment=NSTextAlignmentRight;
        _comment_number_lbl.font = [UIFont fontWithName:@"Arial" size:15];
        _comment_number_lbl.textColor=[UIColor grayColor];
        [self addSubview:_comment_number_lbl];
        
        _like_icon=[[UIImageView alloc] initWithFrame:CGRectMake(245, 270, 22, 22)];
        _like_icon.image=[UIImage imageNamed:@"button_wonderful.png"];
        [self addSubview:_like_icon];
        
        _like_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(215, 270, 30, 22)];
        _like_number_lbl.backgroundColor = [UIColor clearColor];
        _like_number_lbl.textAlignment=NSTextAlignmentRight;
        _like_number_lbl.font = [UIFont fontWithName:@"Arial" size:15];
        _like_number_lbl.textColor=[UIColor grayColor];
        [self addSubview:_like_number_lbl];
    }
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 299, self.bounds.size.width, 1)];
    line_view.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:line_view];
    return self;
}
-(void)setArticle:(Article *)article{
    if(_article==nil||![article.article_id isEqualToString:_article.article_id]){
        _article=article;
        label.text=article.article_title;
        if(article.cover_image_url==nil)
            alImageView.imageURL=article.thumbnail_url;
        else
            alImageView.imageURL=article.cover_image_url;
        _channel_name_lbl.text=[NSString stringWithFormat:@"%@/%@",article.channel_name,[self wrapedTime:article.publish_date]];
        _comment_number_lbl.text=[NSString stringWithFormat:@"%d",article.comments_number.integerValue];
        _like_number_lbl.text=[NSString stringWithFormat:@"%d",article.like_number.integerValue];
    }
}
-(void)openArticle{
    if(_article!=nil&&[self.delegate respondsToSelector:@selector(headerClicked:)]){
        [self.delegate headerClicked:_article];
    }
}
+(CGFloat)preferHeight{
    return 300;
}
-(NSString *)wrapedTime:(NSString *)date{
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * d = [df dateFromString:date];
    
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    
    NSString * timeString = nil;
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha = now - late;
    if (cha/3600 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num= [timeString intValue];
        
        if (num <= 1) {
            
            timeString = [NSString stringWithFormat:@"刚刚"];
            
        }else{
            
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
            
        }
        
    }
    
    if (cha/3600 > 1 && cha/86400 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
        
    }
    
    if (cha/86400 > 1)
        
    {
        
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num = [timeString intValue];
        
        if (num < 2) {
            
            timeString = [NSString stringWithFormat:@"昨天"];
            
        }else if(num == 2){
            
            timeString = [NSString stringWithFormat:@"前天"];
            
        }else if (num > 2 && num <7){
            
            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }else if (num >= 7 && num <= 10) {
            
            timeString = [NSString stringWithFormat:@"1周前"];
            
        }else if(num > 10){
            
            timeString = [NSString stringWithFormat:@"n天前"];
            
        }
        
    }
    return timeString;
}
@end
