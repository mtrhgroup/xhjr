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
    UIScrollView *content_vew=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview: content_vew];
    self.icon_view=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-260)/2, 10, 260, 48)];
    self.icon_view.image=[UIImage imageNamed:@"logo_left_page_top.png"];
    [content_vew addSubview:self.icon_view];
    self.app_description=[[YLLabel alloc] initWithFrame:CGRectMake(5, self.icon_view.frame.origin.y+self.icon_view.frame.size.height+10, self.view.bounds.size.width-10, 370)];
    NSString *description=@"     新华金融客户端突出“高端、专业、独家、深度”特性，围绕全球金融热点，立足中国，放眼世界，打造最中国的金融眼。\n     在这里，您既可以看到影响金融全局事件的权威分析与解读，也能获得影响金融市场的一手资讯。\n     在这里，您既可以了解海内外关注的最新金融热点，也能洞察最贴近您需求的一手资讯。\n     在这里，您既可以获得金融智库的专业服务，也能享受个性化的新华定制服务。\n     在这里，您可以告诉我们您想说的和您想看的金融热点。\n     您可以加入我们，一起决策金融。";
    [self.app_description setText:description];
    self.app_description.font=[UIFont systemFontOfSize:17];
    self.app_description.textColor=[UIColor grayColor];
    [content_vew addSubview:self.app_description];
    self.address=[[UILabel alloc] initWithFrame:CGRectMake(5, self.app_description.frame.origin.y+self.app_description.frame.size.height, self.view.frame.size.width-10, 60)];
    self.address.text=@"地址：北京市宣武门西大街57号\n新华社经济信息编辑部\n邮编：100803";
     self.address.font=[UIFont systemFontOfSize:14];
    self.address.textAlignment=NSTextAlignmentRight;
    self.address.numberOfLines=3;
    self.address.textColor=[UIColor grayColor];
    self.address.shadowColor=[UIColor whiteColor];
    [content_vew addSubview:self.address];
//    self.telephone=[[UILabel alloc] initWithFrame:CGRectMake(5, self.address.frame.origin.y+self.address.frame.size.height+5, self.view.bounds.size.width-10, 15)];
//    self.telephone.text=@"电话：010-63073644";
//    self.telephone.textAlignment=NSTextAlignmentRight;
//    self.telephone.font=[UIFont systemFontOfSize:14];
//    self.telephone.textColor=[UIColor grayColor];
//    self.telephone.shadowColor=[UIColor whiteColor];
//    [content_vew addSubview:self.telephone];
//    self.email=[[UILabel alloc] initWithFrame:CGRectMake(5, self.telephone.frame.origin.y+self.telephone.frame.size.height+5, self.view.bounds.size.width-10, 15)];
//    self.email.font=[UIFont systemFontOfSize:14];
//    self.email.textAlignment=NSTextAlignmentRight;
//    self.email.text=@"E-MAIL: mrcj@xinhua.org";
//    self.email.textColor=[UIColor grayColor];
//    self.email.shadowColor=[UIColor whiteColor];
//    [content_vew addSubview:self.email];
    content_vew.contentSize=CGSizeMake(self.view.bounds.size.width, 600);
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
