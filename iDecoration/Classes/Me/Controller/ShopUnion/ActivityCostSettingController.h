//
//  ActivityCostSettingController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ActivityCostSettingController : SNViewController

@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *costName;

@property (nonatomic, copy) void(^finishBlock)(NSString *name, NSString *cost); // 名称和费用
@end
