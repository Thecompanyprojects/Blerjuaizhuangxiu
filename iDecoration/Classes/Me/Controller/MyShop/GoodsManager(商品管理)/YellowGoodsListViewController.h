//
//  YellowGoodsListViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"

@interface YellowGoodsListViewController : SNViewController
@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, assign) BOOL fromBack; // 从商品管理跳转来的
@property (nonatomic, strong) NSString *collectFlag;

@property(nonatomic,copy)NSString *shopid;
@property (strong, nonatomic) NSDictionary *dataDic;

@property (nonatomic, copy) NSString *companyType;
//座机号
@property(nonatomic,copy)NSString *phone;
//手机号
@property(nonatomic,copy)NSString *telPhone;


@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *shareDescription;
@property (nonatomic,copy) NSString *shareCompanyLogoURLStr;

//装修区域
@property(nonatomic,strong)NSArray *areaList;
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
@property (strong, nonatomic) NSMutableArray *suppleListArr;
@property (strong, nonatomic) NSMutableArray *constructionCase;
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;
@property (strong, nonatomic) NSDictionary *companyDic;
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorModel;
@property (assign, nonatomic) NSInteger code;
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
