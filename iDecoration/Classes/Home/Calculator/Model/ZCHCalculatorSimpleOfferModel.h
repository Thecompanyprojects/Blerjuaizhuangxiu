//
//  ZCHCalculatorSimpleOfferModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCHCalculatorRoomListModel.h"


@interface ZCHCalculatorSimpleOfferModel : NSObject

/**
 *  阳台总价
 */
@property (copy, nonatomic) NSString *balconeyTotal;
/**
 *  卧室总价
 */
@property (copy, nonatomic) NSString *bedroomTotal;
/**
 *  餐厅总价
 */
@property (copy, nonatomic) NSString *dinningTotal;
/**
 *  厨房总价
 */
@property (copy, nonatomic) NSString *kitchenTotal;
/**
 *  整装报价
 */
@property (copy, nonatomic) NSString *packagePrice;
/**
 *  卫生间总价
 */
@property (copy, nonatomic) NSString *washTotal;
/**
 *  客厅总价
 */
@property (copy, nonatomic) NSString *sittingTotal;

/**
 *  其他
 */
@property (copy, nonatomic) NSString *otherTotal;
/**
 *  管理
 */
@property (copy, nonatomic) NSString *managerTotal;
/**
 *  总价
 */
@property (copy, nonatomic) NSString *total;

/**
 *  直接价格
 */
@property (copy, nonatomic) NSString *directTotal;
/**
 *  是否收取设计费
 */
@property (copy, nonatomic) NSString *hasDesign;
/**
 *  是否显示详情
 */
@property (copy, nonatomic) NSString *hideDetail;
/**
 *  是否整装
 */
@property (copy, nonatomic) NSString *isPackage;

/**
 *  房间数组模型
 */
@property (strong, nonatomic) NSArray<ZCHCalculatorRoomListModel *> *roomList;


@end
