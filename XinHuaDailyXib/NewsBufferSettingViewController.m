//
//  NewsBufferSettingViewController.m
//  XinHuaNewsIOS
//
//  Created by apple on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsBufferSettingViewController.h"

@interface NewsBufferSettingViewController ()

@end

@implementation NewsBufferSettingViewController


@synthesize uivaa;
@synthesize uivbb;
@synthesize uivcc;
@synthesize table;

- (void) viewDidLayoutSubviews {
    // only works for iOS 7+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        // snaps the view under the status bar (iOS 6 style)
        viewBounds.origin.y = topBarOffset*-1;
        
        // shrink the bounds of your view to compensate for the offset
        //viewBounds.size.height = viewBounds.size.height -20;
        self.view.bounds = viewBounds;
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
     
    self.navigationController.navigationBar.hidden = YES;
    
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"ext_navbar.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(returnclick:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"系统设置";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    [bimgv addSubview:lab];
    [self.view addSubview:bimgv];
     
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416+(iPhone5?88:0)) style:UITableViewStyleGrouped];
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
    
    
}

-(void)returnclick:(id)sender{
    
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
