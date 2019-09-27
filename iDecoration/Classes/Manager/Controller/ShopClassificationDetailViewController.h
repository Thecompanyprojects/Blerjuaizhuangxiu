//
//  ShopClassificationDetailViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "HomeClassificationDetailViewController.h"
#import "WorkTypeModel.h"

@interface ShopClassificationDetailViewController : HomeClassificationDetailViewController
typedef void(^ShopClassificationDetailViewControllerBlock)(WorkTypeModel *model);
@property (copy, nonatomic) ShopClassificationDetailViewControllerBlock blockDidTouchItem;
- (void)getModelWithTitle:(WorkTypeModel *)titleType;
@end
