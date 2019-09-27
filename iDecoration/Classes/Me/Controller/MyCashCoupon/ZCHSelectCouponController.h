//
//  ZCHSelectCouponController.h
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "ZCHCouponModel.h"

typedef void(^BackData)(NSMutableArray *array);

@interface ZCHSelectCouponController : SNViewController

@property (copy, nonatomic) NSString *companyId;
@property (copy, nonatomic) BackData backBlock;

@property (nonatomic, strong) NSMutableArray *haveSelectArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end
