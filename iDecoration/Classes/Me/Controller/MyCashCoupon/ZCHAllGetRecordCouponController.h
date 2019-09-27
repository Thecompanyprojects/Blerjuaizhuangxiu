//
//  ZCHAllGetRecordCouponController.h
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ZCHAllGetRecordCouponController : SNViewController

@property (copy, nonatomic) NSString *companyId;

@property (nonatomic, copy) NSString *couponId;//该值如果有，表示查询单个券的领取记录

@end
