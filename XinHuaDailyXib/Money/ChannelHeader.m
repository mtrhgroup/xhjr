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
        
        
        alImageView = [[ALImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        alImageView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        alImageView.imageURL = @"";
        [self  addSubview:alImageView];

        alImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArticle)];
        [alImageView addGestureRecognizer:singleTap];
        
        UIView *title_bg_view=[[UIView alloc] initWithFrame:CGRectMake(0, 140, 320, 60)];
        title_bg_view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self addSubview:title_bg_view];
        label = [[UILabel alloc] initWithFrame:CGRectMake(5,0,320-10,60)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor whiteColor];
        label.numberOfLines=2;
        label.font = [UIFont boldSystemFontOfSize:22];
        [title_bg_view addSubview:label];
    }
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
        label.text=article.article_title;
    }
}
-(void)openArticle{
    if(_article!=nil&&[self.delegate respondsToSelector:@selector(headerClicked:)]){
        [self.delegate headerClicked:_article];
    }
}
+(CGFloat)preferHeight{
    return 200;
}

@end
