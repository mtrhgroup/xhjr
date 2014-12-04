//
//  ListCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "HomeCell.h"
#import "ALImageView.h"
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
        thumbnail_view = [[ALImageView alloc] initWithFrame:CGRectMake(320-8-93, 40, 93, 70)];
        thumbnail_view.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:thumbnail_view];
        
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 320-16, 30)];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont systemFontOfSize:22];
        title_label.numberOfLines=3;
        [[self contentView] addSubview:title_label];
        
        _channel_name_lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 90, 222, 20)];
        _channel_name_lbl.backgroundColor = [UIColor clearColor];
        _channel_name_lbl.font = [UIFont systemFontOfSize:15];
        _channel_name_lbl.textColor=[UIColor grayColor];
        [[self contentView] addSubview:_channel_name_lbl];
        
        
        summary_label = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, 210, 60)];
        summary_label.backgroundColor = [UIColor clearColor];
        summary_label.font = [UIFont systemFontOfSize:17];
        summary_label.textColor=[UIColor grayColor];
        summary_label.numberOfLines=2;
        [[self contentView] addSubview:summary_label];
        
        _movie_image_view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moviemaker.png"]];
        _movie_image_view.frame=CGRectMake(self.bounds.size.width-30, (70-16)/2, 16, 16);
        _movie_image_view.hidden=YES;
        [[self contentView] addSubview:_movie_image_view];
        
    }
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 119, self.bounds.size.width, 1)];
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
            thumbnail_view.imageURL=nil;
            thumbnail_view.hidden=YES;
        }else{
            thumbnail_view.hidden=NO;
            thumbnail_view.imageURL=article.thumbnail_url;

        }
        title_label.text=article.article_title;
        summary_label.text=article.summary;
        _channel_name_lbl.text=[NSString stringWithFormat:@"%@/%@",article.channel_name,[self wrapedTime:article.publish_date]];
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
    return 120;
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
