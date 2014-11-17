//
//  DemoSubViewController.m
//  NLScrollPagination
//
//  Created by noahlu on 14-8-11.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import "OtherDailyViewController.h"
#import "ArticleViewController.h"
@interface OtherDailyViewController ()
@property(nonatomic, strong)DailyArticles *daily_articles;
@end

@implementation OtherDailyViewController
@synthesize service=_service;
@synthesize daily_articles=_daily_articles;
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"subCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor grayColor];
    cell.textLabel.text = @"Page Two Text";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article * article = [self.daily_articles.articles objectAtIndex:indexPath.row];
    ArticleViewController *vc=[[ArticleViewController alloc] initWithAritcle:article];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
