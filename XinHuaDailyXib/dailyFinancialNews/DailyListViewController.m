//
//  DailyListViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "DailyListViewController.h"
#import "OtherDailyViewController.h"
@interface DailyListViewController ()
@property(nonatomic,strong)NSString *date;
@property(nonatomic, strong)NSArray *articles;
@end

@implementation DailyListViewController
@synthesize service=_service;
@synthesize date=_date;
@synthesize articles=_articles;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.date=@"20141114";
    [self fetchArticlesFromNET];
    self.subTableViewController = [[OtherDailyViewController alloc] init];
}
-(void)fetchArticlesFromNET{
    [self.service fetchDailyArticlesFromNETWithChannel:AppDelegate.channel time:self.date successHandler:^(NSArray *articles) {
        self.articles=[self.service fetchDailyArticlesFromDBWithChannel:AppDelegate.channel date:@"2014-11-14"];
        [super.tableView reloadData];
    } errorHandler:^(NSError *error) {
        // <#code#>
    }];
}
-(void)fetchArticlesFromDB{
    self.articles=[self.service fetchDailyArticlesFromDBWithChannel:AppDelegate.channel date:self.date];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellname";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text=((Article *)[self.articles objectAtIndex:indexPath.row]).article_title;
    return cell;
}
@end
