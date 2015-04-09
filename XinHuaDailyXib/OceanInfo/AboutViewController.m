//
//  AboutViewController.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "AboutViewController.h"
#import "GlobalVariablesDefine.h"
#import "NavigationController.h"
#import "YLLabel.h"
@interface AboutViewController ()
@property(nonatomic,strong)UIImageView *icon_view;
@property(nonatomic,strong)YLLabel *app_description;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UILabel *telephone;
@property(nonatomic,strong)UILabel *email;

@end

@implementation AboutViewController
@synthesize icon_view=_icon_view;
@synthesize app_description=_app_description;
@synthesize address=_address;
@synthesize telephone=_telephone;
@synthesize email=_email;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"关于";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_waterwave.png"]]];
    UIScrollView *content_vew=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview: content_vew];
    self.icon_view=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-230)/2, 10, 230, 68)];
    self.icon_view.image=[UIImage imageNamed:@"logo_left_page_top.png"];
    [content_vew addSubview:self.icon_view];
    self.app_description=[[YLLabel alloc] initWithFrame:CGRectMake(5, self.icon_view.frame.origin.y+self.icon_view.frame.size.height+10, self.view.bounds.size.width-10, 350)];
    NSString *description=@"   《经略海洋》客户端突出“高端、专业、独家、深度”的特性，围绕国家海洋强国战略做文章，是把握中国海洋事业发展大局的第一移动端电子刊物。\n     在这里，你不仅可以获得对于国家海洋战略的全方位解读，还可以直接与海洋战略参与者零距离对话；\n     在这里，你不仅可以知道别人在做什么，还可以知道别人认为你在做些什么；\n     在这里，你不仅可以享受海洋智库的专业服务，还可以点将聚议，发表你的真知灼见，享受全中国最懂海洋的私人定制；\n     在这里，……\n     有时候，这就够了。\n     加入我们，一起观海听韬，经略海洋。";
    [self.app_description setText:description];
    self.app_description.font=[UIFont systemFontOfSize:17];
    self.app_description.textColor=[UIColor grayColor];
    
    [content_vew addSubview:self.app_description];
    self.app_description.frame=CGRectMake(10, self.icon_view.frame.origin.y+self.icon_view.frame.size.height+10, self.view.bounds.size.width-20, 400);
    self.address=[[UILabel alloc] initWithFrame:CGRectMake(10, self.app_description.frame.origin.y+self.app_description.frame.size.height+20, self.view.frame.size.width-20, 40)];
    self.address.text=@"地址：北京市宣武门西大街57号\n新华社经济信息编辑部";
    self.address.font=[UIFont systemFontOfSize:14];
    self.address.textAlignment=NSTextAlignmentRight;
    self.address.numberOfLines=2;
    self.address.textColor=[UIColor grayColor];
    self.address.shadowColor=[UIColor whiteColor];
    [content_vew addSubview:self.address];
    self.telephone=[[UILabel alloc] initWithFrame:CGRectMake(10, self.address.frame.origin.y+self.address.frame.size.height+5, self.view.bounds.size.width-20, 15)];
    self.telephone.text=@"邮编：100803";
    self.telephone.textAlignment=NSTextAlignmentRight;
    self.telephone.font=[UIFont systemFontOfSize:14];
    self.telephone.textColor=[UIColor grayColor];
    self.telephone.shadowColor=[UIColor whiteColor];
    [content_vew addSubview:self.telephone];
    content_vew.contentSize=CGSizeMake(self.view.bounds.size.width, 700);
    content_vew.scrollEnabled=YES;
    NSLog(@"contentView.height=%f",self.address.bounds.origin.y);
    [((NavigationController *)self.navigationController) setLeftButtonWithImage:[UIImage imageNamed:@"button_topback_default.png"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
-(void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
