//
//  BackGoodsListViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface BackGoodsListViewController : SNViewController

@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, assign) NSInteger agencJob; // 职位ID  只用总经理 经理 可以添加 编辑 删除商品   设计师只能 添加 编辑商品 不能删除
@property (nonatomic, copy) NSString *companyType;

// 是否是执行经理
@property (nonatomic,assign) BOOL implement;   // 总经理、执行经理添加的商品参数名可以应用于整个商品参数

@end
