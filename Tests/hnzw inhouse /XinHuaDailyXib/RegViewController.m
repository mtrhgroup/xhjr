//
//  RegViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 13-1-15.
//
//

#import "RegViewController.h"
#import "Toast+UIView.h"
#import "NewsRegisterTask.h"

@interface RegViewController ()

@end

@implementation RegViewController

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegOKhandler:) name:KUserRegOK object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast:) name:KRegWrong object:nil];
    }
    return self;
}
-(void)RegOKhandler:(NSNotification*) notification{
    [self.view hideToastActivity];
    NSString *info=@"申请已提交，工作人员会与您电话联系！";
    [self.view makeToast:info
                duration:2.0
                position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
}
-(void)showToast:(NSNotification*) notification{
    [self.view hideToastActivity];
    NSString *info=@"提交失败，请查看网路连接！";
    [self.view makeToast:info
                duration:2.0
                position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
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
    [butb addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [butb setBackgroundImage:[UIImage imageNamed:@"backheader.png"] forState:UIControlStateNormal];
    [bimgv addSubview:butb];
    [butb release];
    
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    [self.view addSubview:lab];
    lab.text = @"会员申请";
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    lab.textAlignment = UITextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    [bimgv addSubview:lab];
    [lab release];
    
    [self.view addSubview:bimgv];
    [bimgv release];
    
    UIControl *hiddenView=[[UIControl alloc]initWithFrame:CGRectMake(40,0,280,44)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce:)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [hiddenView addGestureRecognizer:tap];//添加手势到View中
    [self.view addSubview:hiddenView];
    [hiddenView release];


    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"regsn_bg.png"]];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416) style:UITableViewStyleGrouped];
    table.backgroundColor=[UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled=NO;
    [self.view addSubview:table];
    
    
    
    
//    UILabel *tip=[[UILabel alloc] initWithFrame:CGRectMake(10,180+44,310,30)];
//    tip.backgroundColor=[UIColor clearColor];
//    tip.textColor=[UIColor blackColor];
//    tip.text=@"请填写真实信息，以便我们和您联系。";
//    [self.view addSubview:tip];
//    [tip release];
//    UILabel *tip2=[[UILabel alloc] initWithFrame:CGRectMake(10,210+44,310,30)];
//    tip2.backgroundColor=[UIColor clearColor];
//    tip2.textColor=[UIColor blackColor];
//    tip2.text=@"我们的联系电话：010-63077787";
//    [self.view addSubview:tip2];
//    [tip2 release];
	// Do any additional setup after loading the view.
}

-(void)tapOnce:(id)sender
{
    [tf resignFirstResponder];
    [tf2 resignFirstResponder];
    [tf3 resignFirstResponder];
}
-(void)backAction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)reg{
    NSString * username=tf.text;
    NSString * company=tf2.text;
    NSString * telephone=tf3.text;
    if([tf.text isEqualToString:@""]||tf.text==nil){
        [self.view makeToast:@"姓名不能为空！"
                    duration:1.0
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
        return;
    }else if([tf2.text isEqualToString:@""]||tf2.text==nil){
        [self.view makeToast:@"单位不能为空！"
                    duration:1.0
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
        return;
    }else if([tf3.text isEqualToString:@""]||tf3.text==nil){
        [self.view makeToast:@"手机号不能为空！"
                    duration:1.0
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
        return;
    }
    [self.view makeToastActivity:[NSValue valueWithCGPoint:CGPointMake(160, 120)]];
    [[NewsRegisterTask sharedInstance] regWith:username company:company telphone:telephone];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 3;
    }if(section==1){
        return 1;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* str = @"cellid";
    UITableViewCell* cell = [table dequeueReusableCellWithIdentifier:str];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
        
    }
    NSArray *views = [cell subviews];
    for(UIView* view in views)
    {
        if([view isKindOfClass:[UITextField class]] ){
        [view removeFromSuperview];
        }
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:17.0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(indexPath.section==0){
        if (indexPath.row == 0){
            
//            labBuff = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, 44)];
//            NSString* setdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SETDATE"];
//            if (setdate == NULL || [setdate intValue] == 30) {
//                labBuff.text = @"30条";
//            }else if([setdate  intValue] ==  20){
//                labBuff.text =  @"20条";
//            }else if([setdate intValue] == 10){
//                labBuff.text = @"10条";
//            }
//            labBuff.textColor = [UIColor blueColor];
//            labBuff.font = [UIFont fontWithName:@"System" size:17];
//            labBuff.backgroundColor = [UIColor clearColor];
//            [cell addSubview:labBuff];
            
            tf = [[UITextField alloc] initWithFrame:CGRectMake(100,10, 180, 30)];
            tf.placeholder = @"请输入您的真实姓名";
            tf.textAlignment = UITextAlignmentLeft;
            tf.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
         
            [cell addSubview:tf];
            [tf release];
            cell.textLabel.text = @"姓名：";
             cell.accessoryType=UITableViewCellAccessoryNone;
        }else if(indexPath.row == 1){
            tf2 = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 180, 30)];
            tf2.placeholder = @"请输入您的单位名称";
            tf2.textAlignment = UITextAlignmentLeft;
            tf2.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
            [cell addSubview:tf2];
            [tf2 release];
            cell.textLabel.text = @"单位：";
            cell.accessoryType=UITableViewCellAccessoryNone;
        }else if(indexPath.row==2){
            tf3 = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 180, 30)];
            tf3.placeholder = @"请输入您的联系电话";
            tf3.keyboardType= UIKeyboardTypePhonePad;
            tf3.textAlignment = UITextAlignmentLeft;
            tf3.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
            [cell addSubview:tf3];
            [tf3 release];
            cell.textLabel.text = @"手机号：";
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }else if(indexPath.section==1){
//        UIButton *requestbu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        requestbu.frame = CGRectMake(0, 0, 110, 44);
//        [requestbu setTitle:@"提交" forState:UIControlStateNormal];
//        //[regbu setBackgroundImage:[UIImage imageNamed:@"reg_reg.png"] forState:UIControlStateNormal];
//        [requestbu addTarget:self action:@selector(reg:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:requestbu];
        cell.textLabel.textColor = [UIColor whiteColor];
         cell.textLabel.text = @"提交";
        cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        cell.backgroundColor=[UIColor redColor];

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        [self reg];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
