//
//  EditGoodsParameterViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface EditGoodsParameterViewController : SNViewController

@property (nonatomic, copy) void(^completeBlock)(NSArray *listArray);
// 列表数组 或服务数组
@property (nonatomic, strong) NSMutableArray *listArray;
// 如果列表数组或服务数组为空时 默认的数据项
@property (nonatomic, strong) NSArray *defaultTitleArray;
@property (nonatomic, strong) NSString *topTitle;

@end
