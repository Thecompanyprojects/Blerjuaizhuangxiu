//
//  ZCHCooperateController.h
//  iDecoration
//
//  Created by 赵春浩 on 2017/10/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"

@interface ZCHCooperateController : SNViewController

@property (nonatomic, copy) NSString *companyId;

//是否是公司
@property(nonatomic,assign) BOOL  iscompany;
// 装修区域
@property (strong, nonatomic) NSMutableArray *areaArr;
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
@property (strong, nonatomic) NSMutableArray *suppleListArr;
@property (strong, nonatomic) NSMutableArray *constructionCase;
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;
@property (strong, nonatomic) NSDictionary *companyDic;
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorModel;
@property (assign, nonatomic) NSInteger code;

// 2: 表示点击合作企业进入的不可以再次进行跳转
@property (copy, nonatomic) NSString *times;
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
