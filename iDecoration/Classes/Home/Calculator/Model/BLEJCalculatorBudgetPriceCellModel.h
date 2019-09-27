//
//  BLEJCalculatorBudgetPriceCellModel.h
//  Calculator
//
//  Created by 赵春浩 on 17/5/2.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEJCalculatorBudgetPriceCellModel : NSObject

/**
 *  作用名称
 */
@property (copy, nonatomic) NSString *name;
/**
 *  面积
 */
@property (copy, nonatomic) NSString *area;
/**
 *  单价
 */
@property (copy, nonatomic) NSString *price;
/**
 *  总价
 */
@property (copy, nonatomic) NSString *totalPrice;
/**
 *  工艺
 */
@property (copy, nonatomic) NSString *supplementTech;
/**
 *  标记用哪种cell  (1 : 面积  平米  单价  元  2: 数量  ""  单价  元  3: 直接  元  单价  %  4: 金额 元 单价  %)
 */
@property (copy, nonatomic) NSString *type;
// 单位名
@property (copy, nonatomic) NSString *unitName;


@end
