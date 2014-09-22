//
//  NewsFavorManager.m
//  CampusNewsLetter
//
//  Created by apple on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsFavorManager.h"
static NewsFavorManager *instance;
@implementation NewsFavorManager
+(NewsFavorManager *)sharedInstance{
    if(instance==nil){
        instance=[[NewsFavorManager alloc]init];
    }
    return instance;
}
- (id)init
{
    if (self = [super init]) {
        NSArray *pathf=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *pathnew=[pathf objectAtIndex:0];
        NSString *dirname = [pathnew stringByAppendingFormat:@"/favorDir"];
        [[NSFileManager defaultManager] createDirectoryAtPath:dirname withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return self;
}
-(BOOL)iscollected:(UIWebView *)webview{
    NSString *articleTitle = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"articleTitle %@",articleTitle);
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"fav.plist"];   //获取路径
    NSMutableDictionary* dict = nil;
    dict = [[ NSMutableDictionary alloc ] initWithContentsOfFile:filename];
    id result = [dict objectForKey: articleTitle];
    [dict release];
    if (result != nil) {
        return true;
    }else{
        return false;
    }
}
-(void)saveArticle:(UIWebView *)webview{
    NSString *currentURL = [webview stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSString *articleTitle = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *htmlStr = [webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    NSString *urls=[webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img').length"];
    //NSString *head = [[self.view.subviews objectAtIndex:2] stringByEvaluatingJavaScriptFromString:@"document.head.innerHTML"];
    NSLog(@"head__%@",currentURL);
    NSLog(@"detailHTML___%@",htmlStr);
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"fav.plist"];   //获取路径
    NSLog(@"colect_filename_%@",filename);
    
    NSArray *pathf=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *pathnew=[pathf objectAtIndex:0];
    NSString *dirname = [pathnew stringByAppendingFormat:@"/favorDir"];
    
    NSMutableDictionary* dict = nil;
    
    dict = [[ NSMutableDictionary alloc ] initWithContentsOfFile:filename];
    
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    NSString*  timeStr =  [NSString stringWithFormat:@"%qu",[[NSDate date] timeIntervalSince1970]];
    NSString* tempFile = [NSString stringWithFormat:@"%@%d.htm",timeStr,rand()*100];
    NSString* contFileName = [NSString stringWithFormat:@"%@/%@",dirname,tempFile];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if ( [fm fileExistsAtPath:contFileName] == NO) {
        [fm createFileAtPath:contFileName contents:nil attributes:nil];  //创建一个存储文件
        NSLog(@"create file !");
    }
    [htmlStr writeToFile:contFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [dict setObject:contFileName forKey:articleTitle];
    
    if ( [dict writeToFile:filename atomically:YES]) {
        NSLog(@"NEWS_contetn_datailHtml_收藏成功");
    }else{
        NSLog(@"NEWS_contetn_datailHtml__收藏失败");
    }
    [dict release];
    
    //创建img文件夹 保存css
     NSLog(@"AAA");
    NSArray *pathab=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *pathabnew=[pathab objectAtIndex:0];
    NSString *imgDirName = [pathabnew stringByAppendingFormat:@"/favorDir/Img"];
    if ( ![fm fileExistsAtPath:imgDirName] ) {
        [fm createDirectoryAtPath:imgDirName withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *cssFileName = [imgDirName stringByAppendingFormat:@"/css.css"];
    if (![fm fileExistsAtPath:cssFileName]) {
        [fm createFileAtPath:cssFileName contents:nil attributes:nil];
    }
    NSLog(@"BBB");
    //保存css文件
    NSString *ccsFileURL;
    NSString* cssCont;
    NSLog(@"%@",[[currentURL stringByDeletingLastPathComponent] lastPathComponent]);
    NSLog(@"%@",path);
    NSLog(@"%@",currentURL);
    if([currentURL rangeOfString:@"http"].location!=NSNotFound){
        ccsFileURL=[[currentURL stringByDeletingLastPathComponent] stringByAppendingString:@"/Img/css.css"];
        cssCont = [NSString stringWithContentsOfURL:[NSURL URLWithString:ccsFileURL] encoding:NSUTF8StringEncoding error:nil];
    }else{
         NSLog(@"----");
//        NSString *dirStr=[[currentURL substringToIndex:[currentURL rangeOfString:[currentURL lastPathComponent]].location] substringFromIndex:[currentURL rangeOfString:path].location];
         NSLog(@"====");
        NSString *subPath=[[currentURL stringByDeletingLastPathComponent] lastPathComponent];
        path=[path stringByAppendingString:@"/"];
        ccsFileURL=[[path stringByAppendingString:subPath] stringByAppendingString:@"/Img/css.css"];
//        NSString *dirStr=[currentURL substringToIndex:[currentURL rangeOfString:[currentURL lastPathComponent]].location];
//        ccsFileURL=[dirStr stringByAppendingString:@"/Img/css.css"];
        NSLog(@"ccsFileURL %@",ccsFileURL);
        cssCont = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:ccsFileURL] encoding:NSUTF8StringEncoding error:nil];
    }
    [cssCont writeToFile:cssFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    NSLog(@"CCC");
    //创建imags文件夹
    NSArray *pathabc=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *pathabnewd=[pathabc objectAtIndex:0];
    NSString *imgDirNames = [pathabnewd stringByAppendingFormat:@"/favorDir/Imgs"];
    if ( ![fm fileExistsAtPath:imgDirNames] ) {
        [fm createDirectoryAtPath:imgDirNames withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSLog(@"DDD");
    //找出所有的图片名称
    
    
    int urls_length=[urls intValue];
    for(int i=0;i<urls_length;i++){
        NSString *imgURLStr=[webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].getAttribute(\"src\")",i]];
        NSData *data;
        if([currentURL rangeOfString:@"http"].location!=NSNotFound){
            NSString *imgFileURL=[[currentURL stringByDeletingLastPathComponent] stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"/",imgURLStr]];
            NSLog(@"imgFileURL %@",imgFileURL);
            data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgFileURL]];
        }else{
            NSString *subPath=[[currentURL stringByDeletingLastPathComponent] lastPathComponent];
            path=[[path stringByAppendingString:subPath] stringByAppendingString:@"/"];
            NSString *imgFileURL=[path stringByAppendingString:imgURLStr];
            data=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imgFileURL]];
            
        }
        NSString *tofilename=[imgDirNames stringByAppendingString:[@"/" stringByAppendingString: [imgURLStr lastPathComponent]]];
        [data writeToFile:tofilename atomically:YES];
    }
    
    NSString *video_urls=[webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('a').length"];
    int urls_video_length=[video_urls intValue];
    for(int i=0;i<urls_video_length;i++){
        NSString *imgURLStr=[webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('a')[%d].getAttribute(\"href\")",i]];
        NSData *data;
        if([currentURL rangeOfString:@"http"].location!=NSNotFound){
            NSString *imgFileURL=[[currentURL stringByDeletingLastPathComponent] stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"/",imgURLStr]];
            NSLog(@"imgFileURL %@",imgFileURL);
            data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgFileURL]];
        }else{
            NSString *dirStr=[[currentURL substringToIndex:[currentURL rangeOfString:[currentURL lastPathComponent]].location] substringFromIndex:[currentURL rangeOfString:path].location];
            NSString *imgFileURL=[dirStr stringByAppendingString:imgURLStr];
            data=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imgFileURL]];
            
        }
        NSString *tofilename=[imgDirNames stringByAppendingString:[@"/" stringByAppendingString: [imgURLStr lastPathComponent]]];
        [data writeToFile:tofilename atomically:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateFavorList
                                                        object: self];
}
-(void)removeArticle:(UIWebView *)webview{
    NSString *currentURL = [webview stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSString *articleTitle = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *htmlStr = [webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    //NSString *head = [[self.view.subviews objectAtIndex:2] stringByEvaluatingJavaScriptFromString:@"document.head.innerHTML"];
    NSLog(@"head__%@",currentURL);
    NSLog(@"detailHTML___%@",htmlStr);
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"fav.plist"];   //获取路径
    NSLog(@"colect_filename_%@",filename);
    
    NSArray *pathf=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *pathnew=[pathf objectAtIndex:0];
    NSString *dirname = [pathnew stringByAppendingFormat:@"/favorDir"];
    
    NSMutableDictionary* dict = nil;
    
    dict = [[ NSMutableDictionary alloc ] initWithContentsOfFile:filename];
    
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    NSString*  timeStr =  [NSString stringWithFormat:@"%qu",[[NSDate date] timeIntervalSince1970]];
    NSString* tempFile = [NSString stringWithFormat:@"%@%d.htm",timeStr,rand()*100];
    NSString* contFileName = [NSString stringWithFormat:@"%@/%@",dirname,tempFile];
    [[NSFileManager defaultManager] removeItemAtPath:contFileName error:nil];
    [dict removeObjectForKey:articleTitle];
    
    if ( [dict writeToFile:filename atomically:YES]) {
        NSLog(@"NEWS_contetn_datailHtml_收藏成功");
    }else{
        NSLog(@"NEWS_contetn_datailHtml__收藏失败");
    }
    [dict release];
    //找出所有的图片名称
    NSLog(@"AAA");
    NSString *urls=[webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img').length"];
    int urls_length=[urls intValue];
    for(int i=0;i<urls_length;i++){
        NSString *imgURLStr=[webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].getAttribute(\"src\")",i]];
        NSArray *pathabc=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *pathabnewd=[pathabc objectAtIndex:0];
        NSString *imgDirNames = [pathabnewd stringByAppendingFormat:@"/favorDir/Imgs"];
        NSString *tofilename=[imgDirNames stringByAppendingString:[@"/" stringByAppendingString: [imgURLStr lastPathComponent]]];
        [[NSFileManager defaultManager] removeItemAtPath:tofilename error:nil];
    }
     NSLog(@"BBB");
    NSString *urls_videos=[webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('a').length"];
    int urls_video_length=[urls_videos intValue];
    for(int i=0;i<urls_video_length;i++){
        NSString *imgURLStr=[webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('a')[%d].getAttribute(\"href\")",i]];
        NSArray *pathabc=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *pathabnewd=[pathabc objectAtIndex:0];
        NSString *imgDirNames = [pathabnewd stringByAppendingFormat:@"/favorDir/Imgs"];
        NSString *tofilename=[imgDirNames stringByAppendingString:[@"/" stringByAppendingString: [imgURLStr lastPathComponent]]];
        [[NSFileManager defaultManager] removeItemAtPath:tofilename error:nil];
    }
    NSLog(@"CCC");
    [[NSNotificationCenter defaultCenter] postNotificationName: KUpdateFavorList
                                                        object: self];
}
-(NSMutableArray *)allArticleTitle{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"fav.plist"];   //获取路径
    NSMutableDictionary* dict = [[ NSMutableDictionary alloc ] initWithContentsOfFile:filename];
    NSMutableArray *all_articles= [[[NSMutableArray alloc] initWithArray:[dict keysSortedByValueUsingComparator:^(id obj1, id obj2){
        return (NSComparisonResult)[obj2 compare:obj1];
    }]] autorelease];
    return all_articles;
}
-(NSMutableArray *)allArticleURL{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"fav.plist"];   //获取路径
    NSMutableDictionary* dict = [[[ NSMutableDictionary alloc ] initWithContentsOfFile:filename] autorelease];
    NSMutableArray *all_urls = [[[NSMutableArray alloc] initWithArray:[dict allValues]]autorelease];
    [all_urls sortUsingComparator:^(id obj1, id obj2){
        return (NSComparisonResult)[obj2 compare:obj1];
    }];
    return all_urls;
}
-(void)removeAll{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"fav.plist"];   //获取路径
    NSMutableDictionary* dict = [[[ NSMutableDictionary alloc ] initWithContentsOfFile:filename] autorelease];
    [dict removeAllObjects];
    [dict writeToFile:filename atomically:YES];
}
-(void)removeArticleWithTitle:(NSString *)title{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"fav.plist"];   //获取路径
    NSMutableDictionary* dict = [[[ NSMutableDictionary alloc ] initWithContentsOfFile:filename] autorelease];
    [dict removeObjectForKey:title];
    [dict writeToFile:filename atomically:YES];
}
@end
