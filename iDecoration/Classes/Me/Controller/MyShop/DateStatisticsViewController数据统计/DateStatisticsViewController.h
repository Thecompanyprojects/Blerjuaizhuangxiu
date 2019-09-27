//
//  DateStatisticsViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <WMPageController/WMPageController.h>
#import "DateStatisticsModel.h"

@interface DateStatisticsViewController : WMPageController

@property (nonatomic, assign) BOOL isShop;
@property (nonatomic, assign) BOOL isHeadOffice;

@property (nonatomic, strong) DateStatisticsModel *sonCompanyDateModel; // 子公司数据统计
@property (nonatomic, strong) NSArray<DateStatisticsModel *> *headCompanyDateModelArray; // 总公司数据数组
@end
