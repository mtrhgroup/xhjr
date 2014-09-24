//
//  InAppPurchaseManager.h
//  XinHuaDailyXib
//
//  Created by apple on 14/9/23.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "SKProduct+LocalizedPrice.h"
#define kInAppPurchaseManagerProductsFetchNotification @"kInAppPurchaseManagerProductsFetchNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
@interface InAppPurchaseManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>{
    SKProduct *product;
    SKProductsRequest *productsRequest;
}
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProduct;
@end
