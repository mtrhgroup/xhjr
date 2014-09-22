//
//  GallerySource.h
//  XinHuaDailyXib
//
//  Created by apple on 13-7-25.
//
//

#import <Foundation/Foundation.h>
#import "PictureNews.h"
#import "FGalleryViewController.h"
@interface GallerySource : NSObject<FGalleryViewControllerDelegate>
@property (retain,nonatomic) NSMutableArray *picturenews_array;
-(id)initWithPictureNewsArray:(NSMutableArray *)array;
-(id)initWithPictureDictionary:(NSDictionary *)dict;
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController*)gallery;
- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index;
- (NSString*)photoGallery:(FGalleryViewController*)gallery captionForPhotoAtIndex:(NSUInteger)index;
- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index;
@end
