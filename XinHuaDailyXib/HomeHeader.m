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
    NSInteger *current_index;
    NSMutableArray *_image_view_array;
}

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        // 定时器 循环
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frameRect.size.width, frameRect.size.height)];
        _scrollview.contentSize = CGSizeMake(frameRect.size.width, frameRect.size.height);
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.delegate =  self;
        _scrollview.backgroundColor = [UIColor whiteColor];
        _scrollview.pagingEnabled = YES;
        _scrollview.bounces=NO;
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
    _image_view_array=[[NSMutableArray alloc] init];
    if([articles count]>0){
        _scrollview.contentSize=CGSizeMake(_scrollview.frame.size.width * [articles count], _scrollview.frame.size.height);
        for(Article *article in articles){
            int index=[articles indexOfObject:article];
            ALImageView *cover_image_view = [[ALImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * index+self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            cover_image_view.placeholderImage = [UIImage imageNamed:@"default_image.png"];
            cover_image_view.imageURL=article.thumbnail_url;
            cover_image_view.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArticle)];
            [cover_image_view addGestureRecognizer:singleTap];
            [_scrollview addSubview:cover_image_view];
        }
        // 取数组最后一张图片 放在第0页
        ALImageView *first_image_view = [[ALImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        first_image_view.placeholderImage = [UIImage imageNamed:@"default_image.png"];
        first_image_view.imageURL=((Article *)[articles lastObject]).thumbnail_url;
        first_image_view.userInteractionEnabled=YES;
        [first_image_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArticle)]];
        [_scrollview addSubview:first_image_view];
        // 添加第1页在最后
        ALImageView *last_image_view = [[ALImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*([articles count]+1), 0, self.frame.size.width, self.frame.size.height)];
        last_image_view.placeholderImage = [UIImage imageNamed:@"default_image.png"];
        last_image_view.imageURL=((Article *)[articles firstObject]).thumbnail_url;
        last_image_view.userInteractionEnabled=YES;
        [last_image_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArticle)]];
        [_scrollview addSubview:last_image_view];
        
        [_scrollview setContentSize:CGSizeMake(self.frame.size.width * ([articles count] + 2), self.frame.size.height)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
        [_scrollview setContentOffset:CGPointMake(0, 0)];
        [_scrollview scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
        _pagecontrol.numberOfPages=[articles count];
        _picTitleLabel.text=((Article *)[articles firstObject]).article_title;
    }
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = _scrollview.frame.size.width;
    int currentPage = floor((_scrollview.contentOffset.x - pagewidth/ ([_articles count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [_scrollview scrollRectToVisible:CGRectMake(320 * [_articles count],0,320,460) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([_articles count]+1))
    {
        [_scrollview scrollRectToVisible:CGRectMake(320,0,320,460) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = _pagecontrol.currentPage; // 获取当前的page
    [_scrollview scrollRectToVisible:CGRectMake(320*(page+1),0,320,460) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((_scrollview.contentOffset.x - pageWidth/([_articles count]+2))/pageWidth)+1;
    page--;
    if(page<0||page==[_articles count])page=0;
    _pagecontrol.currentPage = page;
    _picTitleLabel.text=((Article *)self.articles[page]).article_title;
}
- (void)runTimePage
{
    int page = _pagecontrol.currentPage; // 获取当前的page
    page++;
    page = page > 2 ? 0 : page ;
    _pagecontrol.currentPage = page;
    [self turnPage];
}
-(void)openArticle{
    if([self.delegate respondsToSelector:@selector(touchViewClicked)]){
        [self.delegate touchViewClicked];
    }
}
@end
