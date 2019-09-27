//
//  BLEJBudgetPriceGroupHeaderCell.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLEJBudgetPriceGroupHeaderCellDelegate <NSObject>

@optional
- (void)didClickMinusBtnWithSection:(NSInteger)section andIsSelected:(BOOL)isSeleted;
- (void)didClickPlusBtnWithSection:(NSInteger)section;

@end


@interface BLEJBudgetPriceGroupHeaderCell : UITableViewHeaderFooterView

// 标题
@property (copy, nonatomic) NSString *titleName;
// 总价
@property (copy, nonatomic) NSString *sumPrice;
// 是否旋转-按钮
@property (assign, nonatomic) BOOL isRotate;
// 组标题的index
@property (assign, nonatomic) NSInteger sectionIndex;
// 是否显示+ / -
@property (assign, nonatomic) BOOL isShowPlusAndMinusBtn;
@property (weak, nonatomic) id<BLEJBudgetPriceGroupHeaderCellDelegate> budgetPriceGroupHeaderCellDelegate;

@end
