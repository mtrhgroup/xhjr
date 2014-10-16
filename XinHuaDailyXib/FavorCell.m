//
//  KidsFavorCell.m
//  kidsgarden
//
//  Created by apple on 14/6/27.
//  Copyright (c) 2014年 ikid. All rights reserved.
//

#import "FavorCell.h"
#import "ALImageView.h"
@implementation FavorCell{
    ALImageView *thumbnail_view;
    UILabel *title_label;
    UILabel *summary_label;
    Article *_article;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        thumbnail_view = [[ALImageView alloc] initWithFrame:CGRectMake(8, 8, 72, 54)];
        thumbnail_view.placeholderImage = [UIImage imageNamed:@"placeholder"];
        [[self contentView] addSubview:thumbnail_view];
        
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(90, 8, 222, 20)];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont fontWithName:@"Arial" size:17];
        title_label.numberOfLines=1;
        [[self contentView] addSubview:title_label];
        
        summary_label = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 222, 35)];
        summary_label.backgroundColor = [UIColor clearColor];
        summary_label.font = [UIFont fontWithName:@"Arial" size:13];
        summary_label.numberOfLines=2;
        summary_label.textColor=[UIColor grayColor];
        [[self contentView] addSubview:summary_label];
        
    }
    return self;
}

-(void)setArticle:(Article *)article{
    if(_article==nil||![_article.article_id isEqualToString:article.article_id]){
        _article=article;
        if(article.thumbnail_url==nil||[article.thumbnail_url isEqualToString:@""]){
            title_label.frame=CGRectMake(8, 8, self.bounds.size.width-16, 22);
            summary_label.frame=CGRectMake(8, 30, self.bounds.size.width-16, 40);
            thumbnail_view.imageURL=@"";
            thumbnail_view.hidden=YES;
        }else{
            thumbnail_view.hidden=NO;
            thumbnail_view.imageURL=article.thumbnail_url;
            title_label.frame=CGRectMake(90, 8, 222, 22);
            summary_label.frame=CGRectMake(90, 30, 222, 34);
        }
        title_label.text=article.article_title;
        if(article.summary==nil||[article.summary isEqualToString:@""]){
            summary_label.text=article.publish_date;
        }else{
            summary_label.text=article.summary;
        }
        
    }
}

@end
