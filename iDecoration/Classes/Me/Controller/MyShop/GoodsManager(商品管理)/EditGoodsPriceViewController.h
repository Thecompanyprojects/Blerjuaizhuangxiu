//
//  EditGoodsPriceViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
@class GoodsPriceModel;

@interface EditGoodsPriceViewController : SNViewController

@property (nonatomic, copy) void(^completeBlock)(NSArray *priceArray);
// 价格数组
@property (nonatomic, strong) NSMutableArray<GoodsPriceModel *> *priceArray;

@end
