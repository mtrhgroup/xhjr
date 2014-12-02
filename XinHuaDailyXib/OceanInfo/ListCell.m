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
@property(nonatomic,strong)UILabel *comment_number_lbl;
@property(nonatomic,strong)UILabel *like_number_lbl;
@property(nonatomic,strong)UILabel *channel_name_lbl;
@property(nonatomic,strong)UIImageView *like_icon;
@property(nonatomic,strong)UIImageView *comment_icon;
@end

@implementation ListCell{
    ALImageView *thumbnail_view;
    UILabel *title_label;
    UILabel *summary_label;
    Article *_article;
}
@synthesize movie_image_view=_movie_image_view;
@synthesize comment_number_lbl=_comment_number_lbl;
@synthesize like_number_lbl=_like_number_lbl;
@synthesize channel_name_lbl=_channel_name_lbl;
@synthesize comment_icon=_comment_icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        thumbnail_view = [[ALImageView alloc] initWithFrame:CGRectMake(8, 8, 90, 60)];
        thumbnail_view.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:thumbnail_view];
        
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(90, 8, 222, 70)];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont systemFontOfSize:18];
        title_label.numberOfLines=3;
        [[self contentView] addSubview:title_label];
        
        
        summary_label = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 222, 30)];
        summary_label.backgroundColor = [UIColor clearColor];
        summary_label.font = [UIFont systemFontOfSize:15];
        summary_label.textColor=[UIColor grayColor];
        [[self contentView] addSubview:summary_label];
        
        _movie_image_view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moviemaker.png"]];
        _movie_image_view.frame=CGRectMake(self.bounds.size.width-30, (70-16)/2, 16, 16);
        _movie_image_view.hidden=YES;
        [[self contentView] addSubview:_movie_image_view];
        
        _comment_icon=[[UIImageView alloc] initWithFrame:CGRectMake(290, 70, 22, 22)];
        _comment_icon.image=[UIImage imageNamed:@"button_review.png"];
        [self.contentView addSubview:_comment_icon];
        
        _comment_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(260, 70, 30, 22)];
        _comment_number_lbl.backgroundColor = [UIColor clearColor];
        _comment_number_lbl.textAlignment=NSTextAlignmentRight;
        _comment_number_lbl.font = [UIFont fontWithName:@"Arial" size:15];
        _comment_number_lbl.textColor=[UIColor grayColor];
        [[self contentView] addSubview:_comment_number_lbl];
        
        _like_icon=[[UIImageView alloc] initWithFrame:CGRectMake(245, 70, 22, 22)];
        _like_icon.image=[UIImage imageNamed:@"button_wonderful.png"];
        [self.contentView addSubview:_like_icon];
        
        _like_number_lbl = [[UILabel alloc] initWithFrame:CGRectMake(215, 70, 30, 22)];
        _like_number_lbl.backgroundColor = [UIColor clearColor];
        _like_number_lbl.textAlignment=NSTextAlignmentRight;
        _like_number_lbl.font = [UIFont fontWithName:@"Arial" size:15];
        _like_number_lbl.textColor=[UIColor grayColor];
        [[self contentView] addSubview:_like_number_lbl];
    }
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 99, self.bounds.size.width, 1)];
    line_view.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:line_view];
    return self;
}
-(Article *)artilce{
    return _article;
}
-(void)setArticle:(Article *)article{
    if(_article==nil||![_article.article_id isEqualToString:article.article_id]){
        _article=article;
        if(article.thumbnail_url==nil||[article.thumbnail_url isEqualToString:@""]){
            title_label.frame=CGRectMake(8, 5, self.bounds.size.width-16, 65);
            summary_label.frame=CGRectMake(8, 70, self.bounds.size.width-16, 22);
            thumbnail_view.imageURL=nil;
            thumbnail_view.hidden=YES;
        }else{
            thumbnail_view.hidden=NO;
            thumbnail_view.imageURL=article.thumbnail_url;
            title_label.frame=CGRectMake(106, 5, 206, 65);
            summary_label.frame=CGRectMake(106, 70, 206, 22);
        }
        title_label.text=article.article_title;
        summary_label.text=[self wrapedTime:article.publish_date];
        _comment_number_lbl.text=[NSString stringWithFormat:@"%d",article.comments_number.integerValue];
        _like_number_lbl.text=[NSString stringWithFormat:@"%d",article.like_number.integerValue];
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
+(CGFloat)preferHeight{
    return 100;
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
