//
//  PictureViewProxy.h
//  XinHuaDailyXib
//
//  Created by apple on 13-3-5.
//
//

#import <UIKit/UIKit.h>
#import "NewsManagerDelegate.h"
@interface PictureView:UIView<NewsManagerDelegate>{
    @private
    UIImage *_realImage;
    BOOL _loadingThreadHasLaunched;
}
@property(nonatomic,readonly)UIImage *image;
@property(nonatomic,strong)UIImage *waitingImage;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic)BOOL grayStylable;
@property(nonatomic)BOOL isGrayStyle;
@end
