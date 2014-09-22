//
//  CheckUpdateTask.m
//  XinHuaDailyXib
//
//  Created by apple on 13-5-27.
//
//

#import "CheckUpdateTask.h"

@implementation CheckUpdateTask{
    NSString *version;
}
static CheckUpdateTask *instance=nil;
+(CheckUpdateTask *)sharedInstance{
    if(instance==nil){
        instance=[[CheckUpdateTask alloc]init];
    }
    return instance;
}
-(BOOL)hasNewerVersion{
    NSLog(@"%@",KupdateURL);
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:KupdateURL]];
    NSLog(@"hasNewerVersion %@",data);
    if(data==nil) return NO;
    NSMutableDictionary *dic=[((NSMutableArray *)[data objectForKey:@"items"]) objectAtIndex:0];
    NSString *net_version=[((NSMutableDictionary *)[dic objectForKey:@"metadata"]) objectForKey:@"bundle-version"];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *local_version =[infoDict objectForKey:@"CFBundleVersion"];
    NSLog(@"localVersion %@",local_version);
    NSLog(@"hasNewerVersion %@",net_version);
    version=net_version;
    return [self versionCompare:local_version net:net_version];
}
-(NSString *)newVersion{
    return version;
}
-(BOOL)versionCompare:(NSString *)local net:(NSString *)net{
    NSLog(@"lc:%@  sv:%@",local,net);
    NSArray *localArr=[local componentsSeparatedByString:@"."];
    NSArray *netArr=[net componentsSeparatedByString:@"."];
    int local_length=[localArr count];
    int net_length=[netArr count];
    int loop_count=net_length>local_length?net_length:local_length;
    for(int i=0;i<loop_count;i++){
        if([[netArr objectAtIndex:i] intValue]>[[localArr objectAtIndex:i] intValue])
            return YES;
        else if([[netArr objectAtIndex:i] intValue]<[[localArr objectAtIndex:i] intValue])
            return NO;
    }
    return NO;
}
-(NSString *)getNewerVersionDescription{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:KupdateURL]];
    NSLog(@"hasNewerVersion %@",data);
    if(data==nil)return @"";
    NSMutableDictionary *dic=[((NSMutableArray *)[data objectForKey:@"items"]) objectAtIndex:0];
    NSString *subtitle=[((NSMutableDictionary *)[dic objectForKey:@"metadata"]) objectForKey:@"subtitle"];
    return subtitle;
}
@end
