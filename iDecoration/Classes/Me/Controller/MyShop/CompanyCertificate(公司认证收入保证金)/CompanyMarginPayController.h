//
//  CompanyMarginPayController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface CompanyMarginPayController : SNViewController
@property (nonatomic, copy) NSString *companyId;
@property (copy, nonatomic) void(^successBlock)();
@property (nonatomic, copy) NSString *payMoney;


@end
