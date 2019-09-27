//
//  CompanyIntroductController.h
//  iDecoration
//
//  Created by Apple on 2017/5/2.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"

@interface CompanyIntroductController : SNViewController

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, strong) NSString *companyType;

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

// 展现量
@property (nonatomic, copy) NSString *displayNum;
@property (nonatomic, copy) NSString *scanNum; // 浏览量
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
