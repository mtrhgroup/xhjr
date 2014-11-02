//
//  Parser.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//

#import "Parser.h"
#import "NSIks.h"
#import "Channel.h"
#import "Article.h"
#import "Command.h"
@implementation Parser
-(NSArray*)parseChannels:(NSString *) xmlstring{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSIks* xml = [[NSIks alloc] initWithString:xmlstring];
    iks*  item =   [xml firstTagFrom:xml.xmlObject];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    while (item)
    {
        Channel *channel = [[Channel alloc] init];
        channel.channel_id = [xml findValueFrom:item nodeName:@"id" ];
        channel.channel_name = [xml findValueFrom:item nodeName:@"name"];
        channel.description = [xml findValueFrom:item nodeName:@"description"];
        channel.sort_number = [[f numberFromString:[xml findValueFrom:item nodeName:@"sort"]] integerValue];
        channel.home_number=[[f numberFromString:[xml findValueFrom:item nodeName:@"homenum"]] integerValue];
        NSString *type=[xml findValueFrom:item nodeName:@"type"];
        if([type isEqualToString:@"child"]){
            channel.is_leaf=YES;
        }else{
            channel.is_leaf=NO;
        }
        NSString *show_type=[xml findValueFrom:item nodeName:@"showtype"];
        if([show_type isEqualToString:@"list"]){
            channel.show_type=List;
        }else if([show_type isEqualToString:@"pic"]){
            channel.show_type=Grid;
        }else if([show_type isEqualToString:@"tile"]){
            channel.show_type=Tile;
        }
        channel.parent_id=[xml findValueFrom:item nodeName:@"parent"];
        NSString *auth=[xml findValueFrom:item nodeName:@"auth"];
        if([auth isEqualToString:@"1"]){
            channel.need_be_authorized=YES;
        }else{
            channel.need_be_authorized=NO;
        }
        [result addObject:channel];
        item = [xml nextTagFrom:item];
    }
    return result;
}
-(NSArray*)parseArticles:(NSString *)xmlstring{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSIks* xml = [[NSIks alloc] initWithString:xmlstring];
    iks*  item =   [xml firstTagFrom:xml.xmlObject];
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    while (item)
    {
        iks* citem = [xml firstTagFrom: item ];
        NSString *channel_id = [xml  findAttribFrom:item attribname:@"id"];
        NSString* channel_name =[xml findAttribFrom:item attribname:@"name"];
        while(citem)
        {
            Article*  article = [[Article alloc] init];
            article.channel_id=channel_id;
            article.channel_name=channel_name;
            article.article_id=[xml findValueFrom:citem nodeName:@"id"];
            article.article_title = [xml findValueFrom:citem nodeName:@"title"];
            NSString *raw_zip_url = [xml findValueFrom:citem nodeName:@"zipurl"];
            article.zip_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_zip_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
            NSString *raw_page_url =  [xml findValueFrom:citem nodeName:@"pageurl"];
            article.page_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_page_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
            article.publish_date = [xml findValueFrom:citem nodeName:@"inserttime"];
            article.attachments = [xml findValueFrom:citem nodeName:@"attachments"];
            article.summary=[xml findValueFrom:citem nodeName:@"summary"];
            NSString *raw_thumbnail_url=[xml findValueFrom:citem nodeName:@"thumbnail"];
            if(raw_thumbnail_url.length!=0){
                article.thumbnail_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_thumbnail_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
            }else{
                article.thumbnail_url=nil;
            }
            NSString *raw_coverimage_url=[xml findValueFrom:citem nodeName:@"coverimg"];
            if(raw_coverimage_url.length!=0){
                article.cover_image_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_coverimage_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
            }else{
                article.cover_image_url=nil;
            }
            article.visit_number=[xml findValueIntFrom:citem nodeName:@"visit"];
            article.like_number=[xml findValueIntFrom:citem nodeName:@"like"];
            NSString *pn=[xml findValueFrom:citem nodeName:@"pn"];
            if([pn isEqualToString:@"0"]){
                article.is_push=NO;
            }else{
                article.is_push=YES;
            }
            article.is_read=NO;
            [result addObject:article];
            citem = [xml nextTagFrom:citem];
        }
        item = [xml nextTagFrom:item];
    }
    return result;
}
-(NSArray *)parseMoreArticles:(NSString *)xmlstring{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSIks* xml = [[NSIks alloc] initWithString:xmlstring];
    iks*  citem =   [xml firstTagFrom:xml.xmlObject];
    while (citem)
    {
        Article*  article = [[Article alloc] init];
        article.article_id=[xml findValueFrom:citem nodeName:@"id"];
        article.article_title = [xml findValueFrom:citem nodeName:@"title"];
        NSString *raw_zip_url = [xml findValueFrom:citem nodeName:@"zipurl"];
        article.zip_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_zip_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        NSString *raw_page_url =  [xml findValueFrom:citem nodeName:@"pageurl"];
        article.page_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_page_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        article.publish_date = [xml findValueFrom:citem nodeName:@"inserttime"];
        article.attachments = [xml findValueFrom:citem nodeName:@"attachments"];
        article.summary=[xml findValueFrom:citem nodeName:@"summary"];
        NSString *raw_thumbnail_url=[xml findValueFrom:citem nodeName:@"thumbnail"];
        if(raw_thumbnail_url.length!=0){
            article.thumbnail_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_thumbnail_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        }else{
            article.thumbnail_url=nil;
        }
        NSString *raw_coverimage_url=[xml findValueFrom:citem nodeName:@"coverimg"];
        if(raw_coverimage_url.length!=0){
            article.cover_image_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_coverimage_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        }else{
            article.cover_image_url=nil;
        }
        article.visit_number=[xml findValueIntFrom:citem nodeName:@"visit"];
        article.like_number=[xml findValueIntFrom:citem nodeName:@"like"];
        NSString *pn=[xml findValueFrom:citem nodeName:@"pn"];
        if([pn isEqualToString:@"0"]){
            article.is_push=NO;
        }else{
            article.is_push=YES;
        }
        article.is_read=NO;
        [result addObject:article];
        citem = [xml nextTagFrom:citem];
    }
    return result;
}
-(Article *)parseOneArticle:(NSString *)xmlstring{
    NSIks* xml = [[NSIks alloc] initWithString:xmlstring];
    iks*  citem  =  xml.xmlObject;
    if (citem)
    {
        Article*  article = [[Article alloc] init];
        article.article_id=[xml findValueFrom:citem nodeName:@"id"];
        article.article_title = [xml findValueFrom:citem nodeName:@"title"];
        NSString *raw_zip_url = [xml findValueFrom:citem nodeName:@"zipurl"];
        article.zip_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_zip_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        NSString *raw_page_url =  [xml findValueFrom:citem nodeName:@"pageurl"];
        article.page_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_page_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        article.publish_date = [xml findValueFrom:citem nodeName:@"inserttime"];
        article.attachments = [xml findValueFrom:citem nodeName:@"attachments"];
        article.summary=[xml findValueFrom:citem nodeName:@"summary"];
        NSString *raw_thumbnail_url=[xml findValueFrom:citem nodeName:@"thumbnail"];
        if(raw_thumbnail_url.length!=0){
            article.thumbnail_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_thumbnail_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        }else{
            article.thumbnail_url=nil;
        }
        NSString *raw_coverimage_url=[xml findValueFrom:citem nodeName:@"coverimg"];
        if(raw_coverimage_url.length!=0){
            article.cover_image_url=[NSString stringWithFormat:@"%@%@",@"http://mis.xinhuanet.com/sxtv2/Mobile",[raw_coverimage_url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        }else{
            article.cover_image_url=nil;
        }
        article.visit_number=[xml findValueIntFrom:citem nodeName:@"visit"];
        article.like_number=[xml findValueIntFrom:citem nodeName:@"like"];
        NSString *pn=[xml findValueFrom:citem nodeName:@"pn"];
        if([pn isEqualToString:@"0"]){
            article.is_push=NO;
        }else{
            article.is_push=YES;
        }
        article.is_read=NO;
        return article;
    }
    return nil;
}
-(AppInfo *)parseAppInfo:(NSString *)xmlstring{
    if(xmlstring.length<70)return nil;
    NSIks* xml = [[NSIks alloc] initWithString:xmlstring];
    iks*  citem  = xml.xmlObject;
    if (citem)
    {
        __autoreleasing AppInfo*  version_info = [[AppInfo alloc] init];
        version_info.snState=[xml findValueFrom:citem nodeName:@"sn_state"];
        version_info.snMsg=[xml findValueFrom:citem nodeName:@"sn_msg"];
        version_info.groupTitle=[xml findValueFrom:citem nodeName:@"group_title"];
        version_info.groupSubTitle=[xml findValueFrom:citem nodeName:@"group_sub_title"];
        version_info.startImgUrl=[xml findValueFrom:citem nodeName:@"startimage"];
        version_info.gid=[xml findValueFrom:citem nodeName:@"gid"];
        return version_info;
    }
    return nil;
}
-(NSArray *)parseCommands:(NSString *)xmlstring{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSIks* xml = [[NSIks alloc] initWithString:xmlstring];
    iks*  item =   [xml firstTagFrom:xml.xmlObject];
    while (item)
    {
        Command*  action = [[Command alloc] init];
        action.f_id = [xml findValueFrom:item nodeName:@"F_ID"];
        action.f_inserttime=[xml findValueFrom:item nodeName:@"F_InsertTime"];
        action.f_state=[xml findValueFrom:item nodeName:@"F_State"];
        [result addObject:action];
        item = [xml nextTagFrom:item];
    }
    return result;
}
@end
