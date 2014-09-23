//
//  SKProduct+LocalizedPrice.h
//  XinHuaDailyXib
//
//  Created by apple on 14/9/23.
//
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)
@property(nonatomic,readonly)NSString *localizedPrice;
@end
