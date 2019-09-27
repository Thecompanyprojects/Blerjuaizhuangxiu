//
//  GoodsDetailViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"

@interface GoodsDetailViewController : SNViewController

@property (nonatomic, assign) BOOL fromBack; // 从商品管理跳转来的

@property (nonatomic, assign) NSInteger goodsID;
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *flowerNumber;
@property (nonatomic, strong) NSString *pennantnumber;
@property (nonatomic, strong) NSString *focusnumber;
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
@property (strong, nonatomic) NSString *companyId;
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorTempletModel;
@property (assign, nonatomic) NSInteger code;



//职位id
@property (nonatomic,copy) NSString *agencJob;
// 是否是执行经理
@property (nonatomic,assign) BOOL implement;   // 总经理、执行经理添加的商品参数名可以应用于整个商品参数
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
