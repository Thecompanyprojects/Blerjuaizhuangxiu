//
//  PanoramaViewController.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"

@interface PanoramaViewController : SNViewController

//标记页面是从企业跳转还是个人中心
@property(nonatomic,assign)NSInteger tag; //1000:从企业跳转来  2000:从工地跳转来 默认0：从个人中心跳转来

//店铺的ID
@property(nonatomic,copy)NSString *shopID;
@property (nonatomic, copy) NSString *companyType;

@property (strong, nonatomic) NSDictionary *dataDic;

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
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorModel;
@property (assign, nonatomic) NSInteger code;

// 职位id
@property (nonatomic, copy) NSString *jobId;

@property (nonatomic, assign) BOOL isComplete;//从工地进来，是否已交工
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
