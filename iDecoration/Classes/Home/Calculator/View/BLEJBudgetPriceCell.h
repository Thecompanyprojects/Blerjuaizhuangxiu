//
//  BLEJBudgetPriceCell.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEJCalculatorBudgetPriceCellModel.h"
#import "ZCHCalculatorItemsModel.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@protocol BLEJBudgetPriceCellDelegate <NSObject>

@optional
- (void)didClickDeleteBtn:(NSIndexPath *)indexPath;

@end


@interface BLEJBudgetPriceCell : UITableViewCell

//@property (strong, nonatomic) BLEJCalculatorBudgetPriceCellModel *model;
// 是否显示删除按钮
@property (assign, nonatomic) BOOL isShowMinus;
// 用来标记点击的是那个cell
@property (strong, nonatomic) NSIndexPath *indexPath;
// 用于删除按钮的点击事件
@property (weak, nonatomic) id<BLEJBudgetPriceCellDelegate> budgetPriceCellDelegate;

@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *itemModel;

@end
