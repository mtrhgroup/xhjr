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
    self.title=@"关于我们";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.icon_view=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-230)/2, 10, 230, 68)];
    self.icon_view.image=[UIImage imageNamed:@"logo_left_page_top.png"];
    [self.view addSubview:self.icon_view];
    self.app_description=[[YLLabel alloc] initWithFrame:CGRectMake(5, self.icon_view.frame.origin.y+self.icon_view.frame.size.height+5, self.view.bounds.size.width-10, 300)];
    [self.app_description setText:@"《经略海洋》客户端突出“高端、独家、深度”的特性，特别是要围绕国家海洋强国战略做文章，力求成为把握中国海洋事业发展大局的第一移动端电子刊物。\n在这里，你不仅可以获得对于国家海洋战略的全方位解读，还可以直接与海洋战略参与者零距离对话；\n在这里，你不仅可以知道别人在做什么，还可以知道别人认为你在做些什么；\n在这里，你不仅可以享受海洋智库的专业服务，还可以点将聚议，发表你的真知灼见，享受全中国最懂海洋的私人定制；\n在这里，……\n有时候，这就够了。\n加入我们，一起观海听韬，经略海洋。"];
//    self.app_description.numberOfLines=100;
//    self.app_description.shadowColor=[UIColor whiteColor];
    self.app_description.font=[UIFont systemFontOfSize:14];
    self.app_description.textColor=[UIColor grayColor];
    [self.view addSubview:self.app_description];
    self.address=[[UILabel alloc] initWithFrame:CGRectMake(5, self.app_description.frame.origin.y+self.app_description.frame.size.height, self.view.frame.size.width-10, 40)];
    self.address.text=@"新华社经济信息编辑部\n北京市西城区宣武门西大街57号报刊楼514室";
     self.address.font=[UIFont systemFontOfSize:14];
    self.address.textAlignment=NSTextAlignmentRight;
    self.address.numberOfLines=2;
    self.address.textColor=[UIColor grayColor];
    self.address.shadowColor=[UIColor whiteColor];
    [self.view addSubview:self.address];
    self.telephone=[[UILabel alloc] initWithFrame:CGRectMake(5, self.address.frame.origin.y+self.address.frame.size.height+5, self.view.bounds.size.width-10, 15)];
    self.telephone.text=@"电话：86-10-6307-2047";
    self.telephone.textAlignment=NSTextAlignmentRight;
    self.telephone.font=[UIFont systemFontOfSize:14];
    self.telephone.textColor=[UIColor grayColor];
    self.telephone.shadowColor=[UIColor whiteColor];
    [self.view addSubview:self.telephone];
    self.email=[[UILabel alloc] initWithFrame:CGRectMake(5, self.telephone.frame.origin.y+self.telephone.frame.size.height+5, self.view.bounds.size.width-10, 15)];
    self.email.font=[UIFont systemFontOfSize:14];
    self.email.textAlignment=NSTextAlignmentRight;
    self.email.text=@"E-MAIL: jlhy@xinhua.org";
    self.email.textColor=[UIColor grayColor];
    self.email.shadowColor=[UIColor whiteColor];
    [self.view addSubview:self.email];
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
