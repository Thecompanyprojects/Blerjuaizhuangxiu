//
//  ZCHCalculatorPayController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)(void);

@interface ZCHCalculatorPayController : UITableViewController

@property (copy, nonatomic) NSString *companyId;
// 0: 新开通  1: 续费
@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) RefreshBlock refreshBlock;

// YES : 业务员开会员   NO : 公司开会员(或者没传)
@property (assign, nonatomic) BOOL isNotCompany;

// 不传的时候就是正常情况 传值进来就有可能不是给自己开会员
@property (copy, nonatomic) NSString *beOpenedId;

@end
