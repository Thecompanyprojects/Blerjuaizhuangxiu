//
//  DiscountPackageModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/7/24.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "DiscountPackageModel.h"

@implementation DiscountPackageModel

- (NSMutableArray *)arrayPay {
    if (!_arrayPay) {
        _arrayPay = @[@{@"typeName" : @"支付宝", @"typeIcon" : @"zhifubao", @"typeSelected" : @"1"}.mutableCopy, @{@"typeName" : @"微信", @"typeIcon" : @"weixin-1", @"typeSelected" : @"0"}.mutableCopy].mutableCopy;
    }
    return _arrayPay;
}

//- (NSArray *)arrayPayIcon {
//    return @[@"zhifubao", @"weixin-1"];
//}
@end
