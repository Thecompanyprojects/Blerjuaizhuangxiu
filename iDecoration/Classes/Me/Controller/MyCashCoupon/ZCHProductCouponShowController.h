//
//  ZCHProductCouponShowController.h
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "ZCHCouponModel.h"

typedef void(^RefreshBlockproduct)(void);
@interface ZCHProductCouponShowController : UITableViewController

@property (copy, nonatomic) NSString *companyId;
@property (strong, nonatomic) ZCHCouponModel *model;
@property (assign, nonatomic) BOOL isFromCompany;
// 判定是否是从我的代金券进来的
@property (assign, nonatomic) BOOL isMy;
@property (copy, nonatomic) RefreshBlockproduct block;

@end
