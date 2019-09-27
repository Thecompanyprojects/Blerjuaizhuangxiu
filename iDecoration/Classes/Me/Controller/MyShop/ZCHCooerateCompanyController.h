//
//  ZCHCooerateCompanyController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/10/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "SubsidiaryModel.h"

@interface ZCHCooerateCompanyController : SNViewController

@property (copy, nonatomic) NSString *companyId;
@property (assign, nonatomic) BOOL isShop;
// 公司数据模型
@property (nonatomic, strong) SubsidiaryModel *companyModel;

@end
