//
//  LeafChannelViewController.m
//  XinHuaDailyXib
//
//  Created by 刘 静 on 14-10-14.
//
//

#import "LeafChannelViewController.h"

@interface LeafChannelViewController ()

@end

@implementation LeafChannelViewController{
     NSDate *_time_stamp;
     int _refresh_interval_minutes;
}
@synthesize articles_for_cvc=_articles_for_cvc;
- (id)init
{
    self = [super init];
    if (self) {
        _time_stamp=[NSDate distantPast];
        _refresh_interval_minutes=5;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [self reloadArticlesFromDB];
    [super viewWillAppear:animated];
    if([self shouldTriggerRefresh]){
        [self triggerRefresh];
    }
}
-(void)reloadArticlesFromDB{
    self.articles_for_cvc=[self.service fetchArticlesFromDBWithChannel:self.channel topN:10];
    [self refreshUI];
}
-(void)reloadArticlesFromNET{
    [self.service  fetchArticlesFromNETWithChannel:self.channel successHandler:^(NSArray *articles) {
        [self reloadArticlesFromDB];
        [self endRefresh];
        _time_stamp=[NSDate date];
    } errorHandler:^(NSError *error) {
        [self endRefresh];
    }];
}
-(void)loadMoreArticlesFromNET{
    [self.service  fetchMoreArticlesFromNETWithChannel:self.channel last_article:[self.articles_for_cvc.other_articles lastObject]  successHandler:^(NSArray *articles) {
        NSMutableArray *other_articles=[NSMutableArray arrayWithArray:self.articles_for_cvc.other_articles];
        [other_articles addObjectsFromArray:articles];
        self.articles_for_cvc.other_articles=other_articles;
        [self endRefresh];
    } errorHandler:^(NSError *error) {
        //report error to user
    }];
}
-(BOOL)shouldTriggerRefresh{
    NSDate *now=[NSDate date];
    NSTimeInterval date1=[now timeIntervalSinceReferenceDate];
    NSTimeInterval date2=[_time_stamp timeIntervalSinceReferenceDate];
    NSTimeInterval interval=date1-date2;
    if(interval>_refresh_interval_minutes*60){
        return YES;
    }else{
        return NO;
    }
}
-(void)refreshUI{
   
}

-(void)triggerRefresh{
}
-(void)endRefresh{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
