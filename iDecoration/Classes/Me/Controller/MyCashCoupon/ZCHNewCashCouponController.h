//
//  ZCHNewCashCouponController.h
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef void(^RefreshBlock)();

@interface ZCHNewCashCouponController : UITableViewController

@property (copy, nonatomic) NSString *companyId;
@property (copy, nonatomic) RefreshBlock block;

@end
