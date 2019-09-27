//
//  ZCHCalculatorItemsModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHCalculatorItemsModel : NSObject

//deal = 3;
//number = 18;
//sumMoney = 423;
//supplementId = 0;
//supplementName = "\U5899\U9762\U817b\U5b50";
//supplementPrice = "23.5";
//supplementUnit = "\U33a1";
//templeteId = 0;
//templeteTypeNo = 2011;
//supplementTech

/**
 *  关联Id
 */
@property (copy, nonatomic) NSString *templeteId;
/**
 *  类型编号
 */
@property (copy, nonatomic) NSString *templeteTypeNo;
/**
 *  操作：{0：新增，1：修改，2：删除，3:数据库返回数据}
 */
@property (copy, nonatomic) NSString *deal;


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
 *  数量
 */
@property (copy, nonatomic) NSString *number;

/**
 *  总花费
 */
@property (copy, nonatomic) NSString *sumMoney;
@end
