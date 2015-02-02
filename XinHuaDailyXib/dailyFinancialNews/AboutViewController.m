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
    self.view.backgroundColor=VC_BG_COLOR;
    UIScrollView *content_vew=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview: content_vew];
    self.icon_view=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-230)/2, 10, 230, 68)];
    self.icon_view.image=[UIImage imageNamed:@"logo_start_page@2x.png"];
    [content_vew addSubview:self.icon_view];
    self.app_description=[[YLLabel alloc] initWithFrame:CGRectMake(5, self.icon_view.frame.origin.y+self.icon_view.frame.size.height+10, self.view.bounds.size.width-10, 370)];
    NSString *description=@"       每日财经，高管人士的阳光早餐。\n       他们报道财经新闻，我们告诉您财经事件背后的经济规律。\n       《每日财经》为各级政府和企业中高层领导者过滤海内外每日财经大事，对要闻进行动态跟踪和原创性分析，迅速反映国内外重大经济信息，提供方向性、策略性、预警性资讯。\n       我们力争用最小的空间容纳最价值的信息量，帮助用户在第一时间掌握世界财经大势。\n       《每日财经》按焦点－热点－要点的顺序直击事件本源、提供深度解读，每个标题都是观点，各篇稿件皆为分析，一字一句悉数原创。\n       我们以分析性信息为用户答疑解惑，用预警性信息为用户创造真金白银。";

    [self.app_description setText:description];
    self.app_description.font=[UIFont systemFontOfSize:17];
    self.app_description.textColor=[UIColor grayColor];
    [content_vew addSubview:self.app_description];
    self.address=[[UILabel alloc] initWithFrame:CGRectMake(5, self.app_description.frame.origin.y+self.app_description.frame.size.height+10, self.view.frame.size.width-10, 40)];
    self.address.text=@"地址：北京市宣武门西大街57号\n新华社经济信息编辑部";
     self.address.font=[UIFont systemFontOfSize:14];
    self.address.textAlignment=NSTextAlignmentRight;
    self.address.numberOfLines=2;
    self.address.textColor=[UIColor grayColor];
    self.address.backgroundColor=[UIColor clearColor];
    self.address.shadowColor=[UIColor whiteColor];
    [content_vew addSubview:self.address];
    self.telephone=[[UILabel alloc] initWithFrame:CGRectMake(5, self.address.frame.origin.y+self.address.frame.size.height, self.view.bounds.size.width-10, 15)];
    self.telephone.text=@"邮编：100803";
    self.telephone.textAlignment=NSTextAlignmentRight;
    self.telephone.font=[UIFont systemFontOfSize:14];
    self.telephone.textColor=[UIColor grayColor];
    self.telephone.backgroundColor=[UIColor clearColor];
    self.telephone.shadowColor=[UIColor whiteColor];
    [content_vew addSubview:self.telephone];
    content_vew.contentSize=CGSizeMake(self.view.bounds.size.width, 700);
    content_vew.scrollEnabled=YES;
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
