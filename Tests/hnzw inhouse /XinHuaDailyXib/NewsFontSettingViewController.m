//
//  NewsFontSettingViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsFontSettingViewController.h"

@interface NewsFontSettingViewController ()

@end

@implementation NewsFontSettingViewController
@synthesize uivaa;
@synthesize uivbb;
@synthesize uivcc;
@synthesize table;


- (void)viewDidUnload
{
    [super viewDidUnload];
    [uivaa release];
    [uivbb release];
    [uivcc release];
    [table release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    UIImageView* bimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bimgv.userInteractionEnabled = YES;
    bimgv.image = [UIImage imageNamed:@"titlebg.png"];
    UIButton* butb = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    butb.showsTouchWhenHighlighted=YES;
    [butb addTarget:self action:@selector(returnclick:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [butb release];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"系统设置";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    [self.view addSubview:bimgv];
    [bimgv release];
    
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
    
    
    NSString* strFontSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"FONTSIZE"];
    
    if ([strFontSize isEqualToString:@"中"] || strFontSize == NULL) {
        uivbb.hidden = NO;
    }else if([strFontSize isEqualToString:@"大"] ){
        uivaa.hidden = NO;
    }else if([strFontSize isEqualToString:@"小"]){
        uivcc.hidden = NO;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"大";
        [cell addSubview:uivaa];
        
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"中";
        [cell addSubview:uivbb];
        
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"小";
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
    
    NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"FONTSIZE"];
    
    if (setdate != NULL) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FONTSIZE"];
        if(indexPath.row==0){
            [[NSUserDefaults  standardUserDefaults] setObject:@"大" forKey:@"FONTSIZE"];
        }else if(indexPath.row==1){
            [[NSUserDefaults  standardUserDefaults] setObject:@"中" forKey:@"FONTSIZE"];
        }else if(indexPath.row==2){
            [[NSUserDefaults  standardUserDefaults] setObject:@"小" forKey:@"FONTSIZE"];
        }        
        
    }else {
        if(indexPath.row==0){
            [[NSUserDefaults  standardUserDefaults] setObject:@"大" forKey:@"FONTSIZE"];
        }else if(indexPath.row==1){
            [[NSUserDefaults  standardUserDefaults] setObject:@"中" forKey:@"FONTSIZE"];
        }else if(indexPath.row==2){
            [[NSUserDefaults  standardUserDefaults] setObject:@"小" forKey:@"FONTSIZE"];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: KSettingChange
                                                        object: self];
    NSLog(@"didselect__%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"FONTSIZE"]);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *temp=@"字体大小";
    return temp;
}


@end
