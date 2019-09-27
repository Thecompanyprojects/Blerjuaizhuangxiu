//
//  ZCHVoiceReportSettingController.h
//  iDecoration
//
//  Created by 赵春浩 on 2017/11/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCHVoiceReportSettingController : UITableViewController

// 设置的类型  1: 计算报价  2: 客户预约  3: 报名活动
@property (copy, nonatomic) NSString *type;

@end
