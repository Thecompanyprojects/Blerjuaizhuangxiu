//
//  DiscountPackageModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/7/24.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscountPackageModel : NSObject

/**
 详细套餐内容
 */
@property (copy, nonatomic) NSString *discountPackageDetail;

/**
 套餐金额
 */
@property (copy, nonatomic) NSString *money;

/**
 支付方式数组
 */
@property (strong, nonatomic) NSMutableArray *arrayPay;

/**
 是否有更多
 */
@property (assign, nonatomic) BOOL isMore;

@end

NS_ASSUME_NONNULL_END
