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
        channel.sort = [f numberFromString:[xml findValueFrom:item nodeName:@"sort"]];
        channel.home_number=[f numberFromString:[xml findValueFrom:item nodeName:@"homenum"]];
        NSString *type=[xml findValueFrom:item nodeName:@"type"];
        if([type isEqualToString:@"child"]){
            channel.is_leaf=YES;
        }else{
            channel.is_leaf=NO;
        }
        NSString *show_type=[xml findValueFrom:item nodeName:@"show_type"];
        if([show_type isEqualToString:@"list"]){
            channel.show_type=List;
        }else if([show_type isEqualToString:@"grid"]){
            channel.show_type=Grid;
        }
        channel.parent_id=[xml findValueFrom:item nodeName:@"parent"];
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
            article.zip_url = [xml findValueFrom:citem nodeName:@"zipurl"];
            article.page_url =  [xml findValueFrom:citem nodeName:@"pageurl"];
            article.publish_date = [xml findValueFrom:citem nodeName:@"inserttime"];
            article.attachments = [xml findValueFrom:citem nodeName:@"attachments"];
            article.summary=[xml findValueFrom:citem nodeName:@"summary"];
            article.thumbnail_url=[xml findValueFrom:citem nodeName:@"thumbnail"];
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
    iks*  item =   [xml firstTagFrom:xml.xmlObject];
    while (item)
    {
        Article*  article = [[Article alloc] init];
        article.article_id=[xml findValueFrom:item nodeName:@"id"];
        article.article_title = [xml findValueFrom:item nodeName:@"title"];
        article.zip_url = [xml findValueFrom:item nodeName:@"zipurl"];
        article.page_url =  [xml findValueFrom:item nodeName:@"pageurl"];
        article.publish_date = [xml findValueFrom:item nodeName:@"inserttime"];
        article.attachments = [xml findValueFrom:item nodeName:@"attachments"];
        article.summary=[xml findValueFrom:item nodeName:@"summary"];
        article.thumbnail_url=[xml findValueFrom:item nodeName:@"thumbnail"];
        NSString *pn=[xml findValueFrom:item nodeName:@"pn"];
        if([pn isEqualToString:@"0"]){
            article.is_push=NO;
        }else{
            article.is_push=YES;
        }
        article.is_read=NO;
        [result addObject:article];
        item = [xml nextTagFrom:item];
    }
    return result;
}
-(Article *)parseOneArticle:(NSString *)xmlstring{
    NSIks* xml = [[NSIks alloc] initWithString:xmlstring];
    iks*  item  =  xml.xmlObject;
    if (item)
    {
        Article*  article = [[Article alloc] init];
        article.article_id=[xml findValueFrom:item nodeName:@"id"];
        article.article_title = [xml findValueFrom:item nodeName:@"title"];
        article.zip_url = [xml findValueFrom:item nodeName:@"zipurl"];
        article.page_url =  [xml findValueFrom:item nodeName:@"pageurl"];
        article.publish_date = [xml findValueFrom:item nodeName:@"inserttime"];
        article.attachments = [xml findValueFrom:item nodeName:@"attachments"];
        article.summary=[xml findValueFrom:item nodeName:@"summary"];
        article.thumbnail_url=[xml findValueFrom:item nodeName:@"thumbnail"];
        NSString *pn=[xml findValueFrom:item nodeName:@"pn"];
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
