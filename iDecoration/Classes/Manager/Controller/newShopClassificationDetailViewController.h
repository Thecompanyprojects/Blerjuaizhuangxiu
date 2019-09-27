//
//  newShopClassificationDetailViewController.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ShopClassificationDetailViewController.h"
#import "WorkTypeModel.h"

@interface newShopClassificationDetailViewController : ShopClassificationDetailViewController
typedef void(^ShopClassificationDetailViewControllerBlock)(WorkTypeModel *model);
@property (copy, nonatomic) ShopClassificationDetailViewControllerBlock blockDidTouchItem;
- (void)getModelWithTitle:(WorkTypeModel *)titleType;
@end
