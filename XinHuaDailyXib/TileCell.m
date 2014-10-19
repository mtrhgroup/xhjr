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
    Article *_article;
}


- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        alImageView = [[ALImageView alloc] initWithFrame:CGRectMake(0,0 , frameRect.size.width , frameRect.size.height)];
        alImageView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        alImageView.imageURL = @"";
        [[self contentView] addSubview:alImageView];
        UIImageView* imv = [[UIImageView alloc] initWithFrame:CGRectMake(0,frameRect.size.height-20 , frameRect.size.width , 20)];
        imv.image = [UIImage imageNamed:@"heise.png"];
        label = [[UILabel alloc] initWithFrame:CGRectMake(5,0 , frameRect.size.width-5, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Arial" size:15];
        [imv addSubview:label];
        [[self contentView] addSubview:imv];
        
    }
    return self;
}
-(Article *)article{
    return _article;
}
-(void)setArticle:(Article *)article{
    if(_article==nil||![_article.article_id isEqualToString:article.article_id]){
        _article=article;
        label.text=article.article_title;
        if(article.cover_image_url==nil){
            alImageView.imageURL=article.thumbnail_url;
        }else{
            alImageView.imageURL=article.cover_image_url;
        }
    }
}
@end
