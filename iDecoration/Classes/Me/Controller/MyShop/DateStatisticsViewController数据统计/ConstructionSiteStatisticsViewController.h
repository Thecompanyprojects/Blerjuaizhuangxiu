//
//  ConstructionSiteStatisticsViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateStatisticsModel.h"


@interface ConstructionSiteStatisticsViewController : UITableViewController

/* controllerType 活动，工地，计算器共用一个控制器
 如果值为98 为计活动界面
 如果值为99 为计算器界面
 否则为工地界面
 */
@property (nonatomic, assign) NSInteger controllerType;

@property (nonatomic, strong) DateStatisticsModel *sonCompanyDateModel; // 子公司数据统计


@end
