//
//  GridHeader.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import "ChannelHeader.h"
#import "ALImageView.h"
@implementation ChannelHeader{
    ALImageView *alImageView;
    UILabel *label;
    UIButton *btn;
    Article *_article;
}

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        alImageView = [[ALImageView alloc] initWithFrame:frameRect];
        alImageView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        alImageView.imageURL = @"";
        [self  addSubview:alImageView];
        UIImageView* imv = [[UIImageView alloc] initWithFrame:CGRectMake(0,frameRect.size.height-20 , frameRect.size.width , 20)];
        imv.image = [UIImage imageNamed:@"heise.png"];
        label = [[UILabel alloc] initWithFrame:CGRectMake(5,0, frameRect.size.width-5, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Arial" size:15];
        [imv addSubview:label];
        [self addSubview:imv];
        alImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArticle)];
        [alImageView addGestureRecognizer:singleTap];
    }
    return self;
}
-(void)setArticle:(Article *)article{
    if(_article==nil||![article.article_id isEqualToString:_article.article_id]){
        _article=article;
        label.text=article.article_title;
        if(article.cover_image_url==nil)return;
        
        alImageView.imageURL=article.cover_image_url;
    }
}
-(void)openArticle{
    if(_article!=nil&&[self.delegate respondsToSelector:@selector(headerClicked:)]){
        [self.delegate headerClicked:_article];
    }
}

@end
