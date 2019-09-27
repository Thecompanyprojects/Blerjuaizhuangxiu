//
//  StaffPageViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/11/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "SNNavigationController.h"

@interface StaffPageViewController : SNViewController

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *teamType; // 1010:设计团队 1011：优秀工长 1006：优秀监理 1025：施工团队,-2:业务员，-3管理

@property (nonatomic, copy) NSString *companyType;
@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, assign) NSInteger index;


@property (nonatomic, assign) BOOL isShop;

//座机号
@property(nonatomic,copy)NSString *phone;
//手机号
@property(nonatomic,copy)NSString *telPhone;


//装修区域
@property(nonatomic,strong)NSArray *areaList;
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
@property (strong, nonatomic) NSMutableArray *suppleListArr;
@property (strong, nonatomic) NSMutableArray *constructionCase;
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;
@property (strong, nonatomic) NSDictionary *companyDic;
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorTempletModel;
@property (assign, nonatomic) NSInteger code;

@property (nonatomic, copy) NSString *dispalyNum;

@property (assign, nonatomic) SNNavigationController *nav;

@end
