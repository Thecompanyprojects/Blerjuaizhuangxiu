//
//  BLEJCalculatorBottomShadowView.h
//  Calculator
//
//  Created by 赵春浩 on 17/5/4.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLEJCalculatorBudgetPriceCellModel;
@class BLEJCalculatorBaseAndSuppleListModel;
@class ZCHCalculatorItemsModel;

#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@interface BLEJCalculatorBottomShadowView : UIView

// 1 弹出pickView  2  弹出自定义视图(带面积)  3 不带面积
@property (assign, nonatomic) int viewType;
// pickView的内容数组
@property (strong, nonatomic) NSArray *dataArr;

// 这个用于弹出视图2的时候那些可以进行编辑(0: 什么都可以编辑  1: 只可以编辑面积 2: 可以编辑单价和工艺)
@property (copy, nonatomic) NSString *edittingType;
// 这个是用来设置显示的文字 (0 : 面积 平米 单价 元  1: 面积 平米 单价 %  2: 数量 自定义单位 单价 元  3: 单位 空 单价 元)
@property (copy, nonatomic) NSString *showType;

@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *allcalModel;
//@property (strong, nonatomic) ZCHCalculatorItemsModel *itemModel;
// 数据模型
//@property (strong, nonatomic) BLEJCalculatorBudgetPriceCellModel *model;
// 用于编辑模板的模型
//@property (strong, nonatomic) BLEJCalculatorBaseAndSuppleListModel *baseAndSuppleListModel;


@end
