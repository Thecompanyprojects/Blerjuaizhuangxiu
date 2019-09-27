//
//  SureIncomeDetailController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "CompanyIncomeModel.h"

@interface SureIncomeDetailController : SNViewController

// 公司收入已到账收入列表跳转过来 传的信息
@property (nonatomic, strong) CompanyIncomeModel *companyIncomeModel;
@end
