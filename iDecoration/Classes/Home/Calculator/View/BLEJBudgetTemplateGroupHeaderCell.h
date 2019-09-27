//
//  BLEJBudgetTemplateGroupHeaderCell.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCHSimpleSettingRoomModel;

@protocol BLEJBudgetTemplateGroupHeaderCellDelegate <NSObject>

@optional
- (void)didClickMinusBtnWithSection:(NSInteger)section andIsSelected:(BOOL)isSeleted;
- (void)didClickPlusBtnWithSection:(NSInteger)section;

@end

@interface BLEJBudgetTemplateGroupHeaderCell : UITableViewHeaderFooterView

// 是否显示+ / -
@property (assign, nonatomic) BOOL isShowMinusAndPlusBtn;
// 组标题内容
@property (copy, nonatomic) NSString *title;
// 减号是否被点击了(需要旋转)
@property (assign, nonatomic) BOOL isRotate;
// 组标题的index
@property (assign, nonatomic) NSInteger sectionIndex;
@property (weak, nonatomic) id<BLEJBudgetTemplateGroupHeaderCellDelegate> budgetTemplateGroupHeaderCellDelegate;

@property (strong, nonatomic) ZCHSimpleSettingRoomModel *model;
@end
