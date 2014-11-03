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
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        alImageView = [[ALImageView alloc] initWithFrame:CGRectMake(10,0 , 320-20 , 200)];
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
    dot_line_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 69, self.bounds.size.width, 1)];
    [self addSubview:dot_line_view];
    UIGraphicsBeginImageContext(dot_line_view.frame.size);   //开始画线
    [dot_line_view.image drawInRect:CGRectMake(0, 0, dot_line_view.frame.size.width, 1)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    float lengths[] = {4,4};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
    CGContextAddLineToPoint(line, self.bounds.size.width, 0.0);
    CGContextStrokePath(line);
    dot_line_view.image = UIGraphicsGetImageFromCurrentImageContext();
    return self;
}
-(Article *)article{
    return _article;
}
-(void)setArticle:(Article *)article{
    if(_article==nil||![_article.article_id isEqualToString:article.article_id]){
        _article=article;
        label.text=article.article_title;
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
