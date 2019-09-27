//
//  SureIncomeController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef NS_ENUM(NSUInteger, MoneyType) {
    MoneyTypeSure, // 确认收钱
    MoneyTypeUnsure, // 未确认收钱
};

@interface SureIncomeController : SNViewController
@property (nonatomic, assign) MoneyType type;
@property (nonatomic, copy) NSString *companyId;
@end
