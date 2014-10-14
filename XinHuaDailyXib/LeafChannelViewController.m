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
@synthesize artilces=_artilces;
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
    [super viewWillAppear:animated];
    if([self shouldTriggerRefresh]){
        [self triggerRefresh];
    }
}
-(void)reloadArticlesFromDB{
    [self.artilces removeAllObjects];
    self.artilces=[NSMutableArray arrayWithArray:[self.service fetchArticlesFromDBWithChannel:self.channel topN:10]];
    [self refreshUI];
}
-(void)reloadArticlesFromNET{
    [self.service  fetchArticlesFromNETWithChannel:self.channel successHandler:^(NSArray *articles) {
        _time_stamp=[NSDate date];
        self.artilces=[NSMutableArray arrayWithArray:articles];
        [self refreshUI];
    } errorHandler:^(NSError *error) {
        //report error to user
    }];
}
-(void)reloadMoreArticles{
    [self.service  fetchMoreArticlesFromNETWithChannel:self.channel last_article:[self.artilces lastObject]  successHandler:^(NSArray *articles) {
        [self.artilces addObjectsFromArray:articles];
        [self refreshUI];
    } errorHandler:^(NSError *error) {
        //report error to user
    }];
}
-(BOOL)shouldTriggerRefresh{
    NSDate *now=[NSDate date];
    NSTimeInterval date1=[now timeIntervalSinceReferenceDate];
    NSTimeInterval date2=[_time_stamp timeIntervalSinceReferenceDate];
    long interval=date1-date2;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
