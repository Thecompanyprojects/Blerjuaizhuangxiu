//
//  ShopDecorateSpecificNeedViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ShopDecorateSpecificNeedViewController : SNViewController
// 图片链接数组
@property (nonatomic, strong) NSArray *imageURLArray;
@property (nonatomic,copy) NSString *companyID;
@property (nonatomic, copy) NSString *companyType;
//装修区域
@property(nonatomic,strong)NSArray *areaList;
@end
