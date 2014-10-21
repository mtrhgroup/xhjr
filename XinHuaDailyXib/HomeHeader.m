//
//  HomeHeader.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-16.
//
//

#import "HomeHeader.h"
#import "ALImageView.h"
@implementation HomeHeader{
    UIScrollView *_scrollview;
    NSArray *_articles;
    UIPageControl *_pagecontrol;
    UILabel *_picTitleLabel;
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frameRect.size.width, frameRect.size.height)];
        _scrollview.contentSize = CGSizeMake(frameRect.size.width, frameRect.size.height);
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = YES;
        _scrollview.delegate =  self;
        _scrollview.backgroundColor = [UIColor whiteColor];
        _scrollview.pagingEnabled = YES;
        ALImageView *cover_image_view = [[ALImageView alloc] initWithFrame:CGRectMake(0, 0, frameRect.size.width, frameRect.size.height)];
        cover_image_view.placeholderImage = [UIImage imageNamed:@"default_image.png"];
        [_scrollview addSubview:cover_image_view];
        _scrollview.bounces=NO;
        [self addSubview:_scrollview];
        //放小横图
        UIImageView* imv = [[UIImageView alloc] initWithFrame:CGRectMake(0,frameRect.size.height-20 , frameRect.size.width , 20)];
        imv.image = [UIImage imageNamed:@"heise.png"];
        _picTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frameRect.size.width-20, 20)];
        _picTitleLabel.backgroundColor = [UIColor clearColor];
        _picTitleLabel.text = @"";
        _picTitleLabel.textColor = [UIColor whiteColor];
        _picTitleLabel.font = [UIFont fontWithName:@"Arial" size:15];
        [imv addSubview:_picTitleLabel];
        [self addSubview:imv];
        _pagecontrol =[[UIPageControl alloc] initWithFrame:CGRectMake(frameRect.size.width-100, -20, 86, 16)];
        _pagecontrol.numberOfPages = 1;
        _pagecontrol.currentPage = 0;
        [imv addSubview:_pagecontrol];
    }
    return self;
}
-(NSArray *)articles{
    return _articles;
}
-(void)setArticles:(NSArray *)articles{
    _articles=articles;
    if([articles count]>0){
        _scrollview.contentSize=CGSizeMake(_scrollview.frame.size.width * [articles count], _scrollview.frame.size.height);
        for(Article *article in articles){
            int index=[articles indexOfObject:article];
            ALImageView *cover_image_view = [[ALImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * index, 0, self.frame.size.width, self.frame.size.height)];
            cover_image_view.placeholderImage = [UIImage imageNamed:@"default_image.png"];
            cover_image_view.imageURL=article.thumbnail_url;
            [_scrollview addSubview:cover_image_view];
            cover_image_view.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArticle)];
            [cover_image_view addGestureRecognizer:singleTap];
            _scrollview.bounces=NO;
        }
        _pagecontrol.numberOfPages=[articles count];
        _picTitleLabel.text=((Article *)[articles firstObject]).article_title;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
        if(page>=0&&page<[self.articles count]){
            _pagecontrol.currentPage = page;
            _picTitleLabel.text=((Article *)self.articles[page]).article_title;
        }
}
-(void)openArticle{
    if([self.delegate respondsToSelector:@selector(clicked)]){
        [self.delegate clicked];
    }
}
@end
