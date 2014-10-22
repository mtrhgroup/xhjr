//
//  NewsBufferSettingViewController.m
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsBufferSettingViewController.h"
#import "NavigationController.h"
@interface NewsBufferSettingViewController ()

@end

@implementation NewsBufferSettingViewController


@synthesize uivaa;
@synthesize uivbb;
@synthesize uivcc;
@synthesize table;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.title=@"保存条数";
     
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    
    
    UIImage* imag = [UIImage imageNamed:@"round_ok.png"];
    
    uivaa = [[UIImageView alloc] initWithFrame:CGRectMake(280, 15, 15, 15)];
    uivaa.image = imag;
    uivaa.tag = 10;
    uivaa.hidden = YES;
    
    uivbb = [[UIImageView alloc] initWithFrame:CGRectMake(280, 15, 15, 15)];
    uivbb.image = imag;
    uivbb.tag = 20;
    uivbb.hidden = YES;
    
    uivcc = [[UIImageView alloc] initWithFrame:CGRectMake(280, 15, 15, 15)];
    uivcc.image = imag;
    uivcc.tag = 30;
    uivcc.hidden = YES;
    
    
    NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
    
    if ([setdate intValue] == 30 || setdate == NULL) {
        uivcc.hidden = NO;
    }else if([setdate intValue] == 10){
        uivaa.hidden = NO;
    }else if([setdate intValue] == 20){
        uivbb.hidden = NO;
    }
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"backheader.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)backAction:(id)sender{
   [self.navigationController popToRootViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    if ( cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    

    if (indexPath.row == 0) {
        cell.textLabel.text = @"10条";
        [cell addSubview:uivaa];
        
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"20条";
        [cell addSubview:uivbb];
        
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"30条";
        [cell addSubview:uivcc];
        
    }
    

    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    uivaa.hidden = YES;
    uivbb.hidden = YES;
    uivcc.hidden = YES;
    
    
    UIImageView* imv = (UIImageView*)[self.view viewWithTag:(indexPath.row+1)*10];
    imv.hidden = NO;
    
  NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
    
    if (setdate != NULL) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SETDATE"];
        [[NSUserDefaults  standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(indexPath.row+1)*10] forKey:@"SETDATE"];
  
    }else {
        
        [[NSUserDefaults  standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(indexPath.row+1)*10] forKey:@"SETDATE"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: KSettingChange
                                                        object: self];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *temp=@"保留条数";
    return temp;
}

@end
