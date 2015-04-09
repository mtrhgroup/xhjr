//
//  FSManager.m
//  XinHuaDailyXib
//
//  Created by apple on 14/10/29.
//
//

#import "FSManager.h"
#define ARTICLE_CACHE_DIR_NAME @"articles"
@interface FSManager()
@property(nonatomic,strong)NSFileManager *manager;
@end
@implementation FSManager
@synthesize manager=_manager;

-(id)init{
    @synchronized(self){
        if(self=[super init]){
            _manager=[NSFileManager defaultManager];
            [self createArticleCacheDir];
        }
    }
    return self;
}
-(NSString *)article_cache_dir_path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0)? [paths objectAtIndex:0] : nil;
    return [NSString stringWithFormat:@"%@/%@",documentpath,ARTICLE_CACHE_DIR_NAME];
}
-(void)createArticleCacheDir{
    BOOL isDir = FALSE;
    BOOL isDirExist=[_manager fileExistsAtPath:self.article_cache_dir_path isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [_manager createDirectoryAtPath:self.article_cache_dir_path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
}
-(NSString *)sizeOfArticleCache{
    if (![_manager fileExistsAtPath:self.article_cache_dir_path]) return 0;
    NSEnumerator *childFilesEnumerator = [[_manager subpathsAtPath:self.article_cache_dir_path] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [self.article_cache_dir_path stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return [NSString stringWithFormat:@"%.2f M",folderSize/(1024.0*1024.0)];
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(void)clearArticleCache{
    NSArray *contents = [_manager contentsOfDirectoryAtPath:self.article_cache_dir_path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
      [_manager removeItemAtPath:[self.article_cache_dir_path stringByAppendingPathComponent:filename] error:NULL];
    }
}

@end
