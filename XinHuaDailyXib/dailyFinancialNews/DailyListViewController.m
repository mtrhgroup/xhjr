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
@property(nonatomic, strong)NSMutableArray *dataListOne;
@end

@implementation DailyListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.dataListOne = [NSMutableArray array];
    for (int i = 0; i<10; i++) {
        [self.dataListOne addObject:[NSString stringWithFormat:@"Page one text %d", i]];
    }
    
    self.subTableViewController = [[OtherDailyViewController alloc] init];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataListOne count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellname";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 40)];
    cellLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    cellLabel.text = [self.dataListOne objectAtIndex:indexPath.row];
    cellLabel.textAlignment = NSTextAlignmentCenter;
    
    [cell.contentView addSubview:cellLabel];
    
    return cell;
}
@end
