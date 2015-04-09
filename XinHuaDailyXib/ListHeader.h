//
//  ListHeader.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/11.
//
//

#import <UIKit/UIKit.h>
#import "Article.h"
@protocol HeaderViewDelegate <NSObject>
-(void)headerClicked:(Article *)article;
@end
@interface ListHeader : UITableViewHeaderFooterView

@end
