//
//  CategoryViewController.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface CategoryViewController : SNViewController
@property (nonatomic, assign) NSInteger index; //1:公司的职位类别
@property (nonatomic, assign) NSInteger comOrShop; //1:公司的职位类别 2.商品职位类别
// 编辑公司或者店铺的时候传进来的
@property (strong, nonatomic) NSDictionary *dic;
// 是不是新创建的
@property (assign, nonatomic) BOOL isNewBuild;

@property (nonatomic, assign) NSInteger defaultJobId;//默认的职位id
@end
