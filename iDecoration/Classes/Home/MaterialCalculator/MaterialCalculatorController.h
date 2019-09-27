//
//  MaterialCalculatorController.h
//  iDecoration
//
//  Created by zuxi li on 2017/7/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface MaterialCalculatorController : SNViewController
// 店铺id
@property (copy, nonatomic) NSString *shopID;
// 是否是云管理会员
@property (copy, nonatomic) NSString *isConVip;

// 展现量
@property (nonatomic, copy) NSString *dispalyNum;
@end
