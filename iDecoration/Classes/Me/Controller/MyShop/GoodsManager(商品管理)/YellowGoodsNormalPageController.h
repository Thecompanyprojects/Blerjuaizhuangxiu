//
//  YellowGoodsNormalPageController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@interface YellowGoodsNormalPageController : SNViewController
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL fromBack; // 从商品管理跳转来的

@property (nonatomic, strong) NSString *collectFlag;

@property(nonatomic,copy)NSString *shopid;
@property (strong, nonatomic) NSDictionary *dataDic;

@property (nonatomic, copy) NSString *companyType;
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

@end
