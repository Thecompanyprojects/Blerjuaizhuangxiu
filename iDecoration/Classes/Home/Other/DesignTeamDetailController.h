//
//  DesignTeamDetailController.h
//  iDecoration
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEJCalculatorTempletModel.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "StaffModel.h"
@class DesignTeamModel;

@interface DesignTeamDetailController : SNViewController


@property (nonatomic, copy) NSString *titleStr;
@property (strong, nonatomic) DesignTeamModel *model;

@property (strong, nonatomic) StaffModel *staffModel;

@property (nonatomic, assign) BOOL isShop;


@property(nonatomic,copy)NSString *companyId;
@property (nonatomic, copy) NSString *companyType;
@property(nonatomic,copy)NSString *phone;
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

//团队类型
@property(nonatomic,copy)NSString *teamType;
@property (nonatomic, copy) NSString *dispalyNum;
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
