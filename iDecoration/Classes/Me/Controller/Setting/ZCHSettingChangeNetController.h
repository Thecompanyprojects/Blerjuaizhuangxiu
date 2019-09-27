//
//  ZCHSettingChangeNetController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef void(^BackRefreshBlock)();
@interface ZCHSettingChangeNetController : SNViewController

@property (strong, nonatomic) NSMutableArray *dataArr;
// 内外网标识 0:内网，1：外网
@property (assign, nonatomic) BOOL isOuter;
@property (copy, nonatomic) BackRefreshBlock refreshBlock;

@end
