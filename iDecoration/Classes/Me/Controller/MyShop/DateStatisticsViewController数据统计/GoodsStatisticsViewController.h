//
//  GoodsStatisticsViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateStatisticsModel.h"

@interface GoodsStatisticsViewController : UITableViewController
// 商品，喊装修共用一个控制器 如果值为99 为喊装修面  999为店铺喊装修页面  否则为工地界面
@property (nonatomic, assign) NSInteger controllerType;

@property (nonatomic, strong) DateStatisticsModel *sonCompanyDateModel; // 子公司数据统计
@end
