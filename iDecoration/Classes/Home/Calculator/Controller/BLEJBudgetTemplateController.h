//
//  BLEJBudgetTemplateController.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "SNViewController.h"
@class SubsidiaryModel;

typedef void(^RefreshBlocktemplete)(void);

@interface BLEJBudgetTemplateController : SNViewController
@property (copy, nonatomic) NSString *stringTextView;
@property (copy, nonatomic) NSString *companyID;
@property (copy, nonatomic) NSString *companyLogo;

@property (copy, nonatomic) NSString *companybname;
//@property (strong, nonatomic) NSString *calculatorType;

@property (nonatomic, strong) SubsidiaryModel *model;

@property (copy, nonatomic) RefreshBlocktemplete refreshBlock;
// 最下面的编辑按钮
@property (strong, nonatomic) UIButton *editBtn;
@property (nonatomic, assign) BOOL isCanEdit; // 是否可以编辑计算器模板   编辑按钮是否隐藏   总经理 经理 设计师可以编辑  其他人不可以编辑
@property (nonatomic, assign) BOOL isNewAdded;
- (void)back;
@end
