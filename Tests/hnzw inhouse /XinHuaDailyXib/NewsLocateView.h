//
//  NewsLocateView.h
//  CampusNewsLetter
//
//  Created by apple on 12-10-23.
//
//

#import <UIKit/UIKit.h>

@interface NewsLocateView : UIActionSheet<UIPickerViewDelegate,UIPickerViewDataSource>{
@private NSArray *collages;
}
@property(nonatomic,retain) NSString *collageTitle;
@property(nonatomic,retain) NSString *collageCode;
@property (retain, nonatomic)UIPickerView *locatePicker;
-(id)initWithFrame:(CGRect)rect delegate:(id)delegate;
-(void)showInView:(UIView *)view;
-(void)removeFromView;
@end
