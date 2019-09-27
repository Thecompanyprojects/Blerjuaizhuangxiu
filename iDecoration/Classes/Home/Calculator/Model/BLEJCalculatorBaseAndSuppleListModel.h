//
//  BLEJCalculatorBaseAndSuppleListModel.h
//  Calculator
//
//  Created by 赵春浩 on 17/5/2.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEJCalculatorBaseAndSuppleListModel : NSObject

//deal = 3;
//number = 0;
//sumMoney = 0;
//supplementId = 169;
//supplementName = "\U55ef\U54e6\U54e6\U54e6";
//supplementPrice = 22;
//supplementTech = "\U8fd9\U54c8";
//supplementUnit = "\U5e73\U65b9\U7c73";
//templeteId = 94;

/**
 *  操作：{0：新增，1：修改，2：删除，3:数据库返回数据}
 */
@property (copy, nonatomic) NSString *deal;
/**
 *  数量
 */
@property (copy, nonatomic) NSString *number;
/**
 *  总花费
 */
@property (copy, nonatomic) NSString *sumMoney;
/**
 *  模板Id(0 : 基础模板)
 */
@property (copy, nonatomic) NSString *supplementId;
/**
 *  (新项目)名称
 */
@property (copy, nonatomic) NSString *supplementName;
/**
 *  单价
 */
@property (copy, nonatomic) NSString *supplementPrice;
/**
 *  工艺
 */
@property (copy, nonatomic) NSString *supplementTech;
/**
 *  单位
 */
@property (copy, nonatomic) NSString *supplementUnit;
/**
 *  关联Id
 */
@property (copy, nonatomic) NSString *templeteId;


@end
