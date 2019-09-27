//
//  ZCHCashCouponController.h
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ZCHCashCouponController : SNViewController

// 是否是从公司页面进来的
@property (assign, nonatomic) BOOL isCanNew;
@property (copy, nonatomic) NSString *companyId;
// 是否可以新建代金券(是否显示领取记录  是否可以看详情)
@property (assign, nonatomic) BOOL isCanNewCoupon;
@property (nonatomic,copy)  NSString *companyName;

@end
