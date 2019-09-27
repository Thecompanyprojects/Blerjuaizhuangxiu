//
//  NewEditGoodsParameterViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface NewEditGoodsParameterViewController : SNViewController
@property (nonatomic, copy) void(^completeBlock)(NSArray *listArray);
// 参数数组， 编辑时已经有的参数
@property (nonatomic, strong) NSMutableArray *listArray;
// 如果列表数组或服务数组为空时 默认的数据项
@property (nonatomic, strong) NSArray *defaultTitleArray;
@property (nonatomic, strong) NSString *topTitle;

@property (nonatomic, assign) BOOL isImplementOrGeneralManager; // 是总经理或执行经理
@property (nonatomic, strong) NSMutableArray *regularArray; // 总经理或执行经理定义的商品参数

@end
