//
//  ShopDetailController.h
//  iDecoration
//
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNNavigationController.h"
#import "SubsidiaryModel.h"
#import "DateStatisticsModel.h"

typedef void(^BackRefreshBlock)();
@interface ShopDetailController : SNViewController

// 公司数据模型
@property (nonatomic, strong) SubsidiaryModel *model;
// 
@property (nonatomic, copy) NSString *jobId;
@property (copy, nonatomic) BackRefreshBlock backRefreshBlock;


@property (nonatomic, strong) DateStatisticsModel *sonCompanyDateModel; // 子公司数据统计

// 是否是执行经理
@property (nonatomic,assign) BOOL implement;
@property (nonatomic,assign) BOOL isfirst;



@end
