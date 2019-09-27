//
//  STYCouponSelectController.h
//  iDecoration
//
//  Created by sty on 2018/2/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface STYCouponSelectController : SNViewController
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *couponId;//礼品券id

@property (nonatomic, copy) void (^arrayBlock)(NSMutableArray *array);
@end
