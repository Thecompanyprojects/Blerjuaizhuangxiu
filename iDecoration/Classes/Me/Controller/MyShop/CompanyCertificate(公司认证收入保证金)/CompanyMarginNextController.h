//
//  CompanyMarginNextController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef NS_ENUM(NSUInteger, MarginType) {
    MarginTypePayment, // 充值
    MarginTypeMakeMoney, // 提现
};
@interface CompanyMarginNextController : SNViewController

@property (nonatomic, assign) MarginType marginType;
@property (nonatomic, copy) NSString *companyId;

@property (copy, nonatomic) void(^backSuccessBlock)();
@end
