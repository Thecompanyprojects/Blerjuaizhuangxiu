//
//  ZCHGoodsDetailViewController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "goodsModel.h"


typedef void(^CHGoodsDetailViewControllerBackBlock)();
@interface ZCHGoodsDetailViewController : SNViewController

@property (strong, nonatomic) NSDictionary *dataDic;

@property (strong, nonatomic) goodsModel *goodModel;

@property (copy, nonatomic) CHGoodsDetailViewControllerBackBlock backBlock;
@property (copy, nonatomic) NSString *productId;


@end
