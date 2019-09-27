//
//  BLEJBudgetTemplateCell.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHCalculatorItemsModel.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@protocol BLEJBudgetTemplateCellDelegate <NSObject>

@optional
- (void)didClickDeleteBtn:(NSIndexPath *)indexPath;

@end

@interface BLEJBudgetTemplateCell : UITableViewCell
// 数据模型
//@property (strong, nonatomic) BLEJCalculatorBaseAndSuppleListModel *model;
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *model;
// 用于标记是否显示删除按钮(以及用户交互)
@property (assign, nonatomic) BOOL isShowMinus;
// 用来标记点击的是那个cell
@property (strong, nonatomic) NSIndexPath *indexPath;
// 用于删除按钮的点击事件
@property (weak, nonatomic) id<BLEJBudgetTemplateCellDelegate> budgetTemplateCellDelegate;
// 用来标记cell的类型(1: 单价显示的是元  2:  单价显示的百分数)
// 0 : 面积 平米 单价 元  1: 面积 平米 单价 %  2: 数量 自定义单位 单价 元
@property (copy, nonatomic) NSString *cellType;

@end
