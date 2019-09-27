//
//  BLEJBudgetGuideController.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/27.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "SNViewController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@class HomeDefaultModel;
@interface BLEJBudgetGuideController : SNViewController

// 基础模板中的其他信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorModel;
//了解我们的数组
@property(nonatomic,strong)HomeDefaultModel *homeModel;

// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;


// 顶部轮播图
@property (strong, nonatomic) NSMutableArray *topImageArr;
// 底部图片
@property (strong, nonatomic) NSArray *bottomImageArr;

//头部视图
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
//底部视图
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;

@property (strong, nonatomic) NSString *display;
@property (strong, nonatomic) NSString *goodcount;


// 跑马视图的电话号码的数组
@property (strong, nonatomic) NSArray *userPhoneArray;
// 公司的装修区域
@property (strong, nonatomic) NSMutableArray *areaArr;
// 全景数组
@property (strong, nonatomic) NSMutableArray *viewList;


// 施工案例
@property (strong, nonatomic) NSMutableArray *constructionCase;
// 推荐到企业的案例
@property (strong, nonatomic) NSMutableArray *caseArr;
// 活动报名人数
@property (strong, nonatomic) NSMutableDictionary *activityDict;
// 合作企业
@property (strong, nonatomic) NSMutableArray *cooperateArr;
// 合作企业cell
@property (strong, nonatomic) UITableViewCell *cooperateCell;

// 以往活动列表
@property (nonatomic, strong) NSMutableArray *acticityArray;
//code
@property (assign, nonatomic) NSInteger code;
// 公司id
@property (nonatomic, copy) NSString *companyID;
// 是否是云管理会员(施工案例是否可以打开)
@property (copy, nonatomic) NSString *isConVip;
//公司名字
@property (strong, nonatomic) NSString* companyName;
// 公司的基本信息
@property (strong, nonatomic) NSMutableDictionary *companyDic;

@property (nonatomic, strong) NSString *shareCompanyLogoURLStr;
// 分享出去的描述
@property (nonatomic, strong) NSString *shareDescription;
// 底部点赞数量
@property (strong, nonatomic) UILabel *goodCountLabel;

// 展现量
@property (nonatomic, copy) NSString *dispalyNum;
//是否是收藏的状态
@property (nonatomic, strong) NSString *collectFlag;

@property (nonatomic,copy) NSString *origin;
@end
