//
//  HeadOfficeDateStatisticsViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "DateStatisticsModel.h"

@interface HeadOfficeDateStatisticsViewController : SNViewController

@property (nonatomic, assign) NSInteger selectedIndex; //

@property (nonatomic, strong) NSArray<DateStatisticsModel *> *headCompanyDateModelArray; // 总公司数据数组
@end
