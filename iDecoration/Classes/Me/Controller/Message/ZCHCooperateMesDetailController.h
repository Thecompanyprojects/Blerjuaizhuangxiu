//
//  ZCHCooperateMesDetailController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/10/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
@class ZCHCooperateListModel;

typedef void(^RefreshBlock)();
@interface ZCHCooperateMesDetailController : SNViewController

@property (strong, nonatomic) ZCHCooperateListModel *model;
@property (copy, nonatomic) RefreshBlock block;

@end
