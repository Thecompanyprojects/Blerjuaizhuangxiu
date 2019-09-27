//
//  ZCHNewsActivityController.h
//  iDecoration
//
//  Created by 赵春浩 on 2017/11/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "SubsidiaryModel.h"

@interface ZCHNewsActivityController : SNViewController
@property (nonatomic, copy) void(^ZCHNewsActivityVipBlock)(void);//开通了公司号码通vip
// 公司数据模型
@property (nonatomic, strong) SubsidiaryModel *model;
// 是否执行经理
@property (nonatomic, assign) BOOL implement;
@end
