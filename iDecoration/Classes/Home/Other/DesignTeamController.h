//
//  DesignTeamController.h
//  iDecoration
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@interface DesignTeamController : SNViewController

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyType;
@property (nonatomic, assign) NSInteger teamType;
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
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
