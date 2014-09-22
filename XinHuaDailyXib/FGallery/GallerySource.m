//
//  GallerySource.m
//  XinHuaDailyXib
//
//  Created by apple on 13-7-25.
//
//

#import "GallerySource.h"
#import "PictureNews.h"
@implementation GallerySource
@synthesize picturenews_array;
-(id)initWithPictureDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.picturenews_array=[dict objectForKey:@"all"];
    }
    return self;
}
-(id)initWithPictureNewsArray:(NSMutableArray *)array{
    self = [super init];
    if (self) {
        self.picturenews_array=array;
    }
    return self;
}
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController*)gallery{
    return [self.picturenews_array count];
}
- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index{
    return FGalleryPhotoSourceTypeLocal;
}
- (NSString*)photoGallery:(FGalleryViewController*)gallery captionForPhotoAtIndex:(NSUInteger)index{
//    PictureNews *item=(PictureNews *)[self.picturenews_array objectAtIndex:index];
//    return [item picture_title];
    return @"";
}
- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index{
//    PictureNews *item=(PictureNews *)[self.picturenews_array objectAtIndex:index];
//    NSLog(@"%@",item.picture_url);
//    return item.picture_url;
    return [self.picturenews_array objectAtIndex:index];
}
@end
