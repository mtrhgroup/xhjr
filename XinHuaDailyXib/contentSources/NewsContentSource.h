//
//  NewsSource.h
//  XinHuaDailyXib
//
//  Created by apple on 13-8-14.
//
//

#import <Foundation/Foundation.h>

@interface NewsContentSource : NSObject
@property(strong,nonatomic)NSString *title;
@property (strong,nonatomic)NSArray *siblings;
@property int index;
-(int)moveDownIndex;
-(int)moveUpIndex;
-(NSURL *)get_current_news;
-(NSURL *)get_previous_news;
-(NSURL *)get_next_news;
-(NSURL *)makeURLwith:(id)item;
@end
