//
//  AppleIAPManager.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AppleIAPManager.h"

#import <IAPShare.h>
#import <IAPHelper.h>


@implementation AppleIAPManager

+ (instancetype)sharedManager {
    static AppleIAPManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)buyFlowerWithIAP:(NSString *)identifer completion:(void (^)(NSString *))completion{
    
    if (!identifer) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow hudShow:@"正在获取订单"];
    
    if (![IAPShare sharedHelper].iap) {
        NSSet *dataSet = [[NSSet alloc] initWithArray:@[@"com.blej.apploader.banner001",@"com.blej.apploader.banner002",@"com.blej.apploader.flower001",@"com.blej.apploader.flower002"]];
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
#ifdef DEBUG
    [IAPShare sharedHelper].iap.production = NO;
#else
    [IAPShare sharedHelper].iap.production = YES;
#endif
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response) {
        if(response) {
            SKProduct* product;
            if ([identifer isEqualToString:@"大锦旗"]) {
                product = [[IAPShare sharedHelper].iap.products objectAtIndex:0];
            }
            if ([identifer isEqualToString:@"小锦旗"]) {
                product = [[IAPShare sharedHelper].iap.products objectAtIndex:1];
            }
            
            if ([identifer isEqualToString:@"一朵"]) {
                product = [[IAPShare sharedHelper].iap.products objectAtIndex:2];
            }
            if ([identifer isEqualToString:@"一束"]) {
                product = [[IAPShare sharedHelper].iap.products objectAtIndex:3];
            }
            
            YSNLog(@"Price: %@",[[IAPShare sharedHelper].iap getLocalePrice:product]);
            YSNLog(@"Title: %@",product.localizedTitle);
            
            [[UIApplication sharedApplication].keyWindow textHUDHiddle];
            [[UIApplication sharedApplication].keyWindow hudShow:@"正在前往商店购买"];
            [[IAPShare sharedHelper].iap buyProduct:product
                                       onCompletion:^(SKPaymentTransaction* trans){
                [[UIApplication sharedApplication].keyWindow textHUDHiddle];
                    NSLog(@"💰💰💰💰💰💰💰💰%ld",(long)trans.transactionState);
               if (trans.transactionState == SKPaymentTransactionStatePurchased) {
                   [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] onCompletion:^(NSString *response, NSError *error) {
                       NSDictionary* rec = [IAPShare toJSON:response];
                       [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                       YSNLog(@"SUCCESS %@",response);
                       // 拿到订单号 返回
                       YSNLog(@"rec: %@", rec);
                       NSDictionary *in_appDic = rec[@"receipt"][@"in_app"][0];
                       NSString *transaction_id = [NSString stringWithFormat:@"%lld", [in_appDic[@"transaction_id"] longLongValue]];
                       YSNLog(@"transaction_id: %@", transaction_id);
                       YSNLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                       completion(transaction_id);
                   }];
               }
               if(trans.transactionState == SKPaymentTransactionStateFailed) {
                   YSNLog(@"Fail");
                   [[UIApplication sharedApplication].keyWindow hudShowWithText:@"交易失败，请稍后再试"];
               }
           }];
        }
    }];
}


- (void)buyBannerWithIAP:(NSString *)identifer completion:(void (^)(NSString *))completion {
    [self buyFlowerWithIAP:@"大锦旗" completion:completion];
}
@end
