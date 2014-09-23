//
//  SKProduct+LocalizedPrice.m
//  XinHuaDailyXib
//
//  Created by apple on 14/9/23.
//
//

#import "SKProduct+LocalizedPrice.h"

@implementation SKProduct (LocalizedPrice)
-(NSString *)localizedPrice{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    return formattedString;
}
@end
