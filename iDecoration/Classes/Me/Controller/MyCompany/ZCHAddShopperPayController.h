//
//  ZCHAddShopperPayController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ZCHAddShopperPayController : UITableViewController

// 判断是否是从添加商家页面进来的
@property (assign, nonatomic) BOOL isAddJoin;
// 店铺Id
@property (copy, nonatomic) NSString *merchantId;
// 公司Id
@property (copy, nonatomic) NSString *companyId;
// 是否添加过该公司 0 表示新增  1 表示添加过(不管其是否过期) 走续费
@property (assign, nonatomic) NSString *isHaveAdd;

@end
