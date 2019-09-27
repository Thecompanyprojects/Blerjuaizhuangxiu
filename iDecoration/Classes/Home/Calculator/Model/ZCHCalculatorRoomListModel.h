//
//  ZCHCalculatorRoomListModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCHCalculatorItemsModel.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@interface ZCHCalculatorRoomListModel : NSObject


/**
 *  地面面积
 */
@property (copy, nonatomic) NSString *floorArea;
/**
 *  名称
 */
@property (copy, nonatomic) NSString *name;
/**
 *  总价
 */
@property (copy, nonatomic) NSString *sum;
/**
 *  类型
 */
@property (copy, nonatomic) NSString *type;
/**
 *  类型
 */
@property (copy, nonatomic) NSString *typeClass;
/**
 *  墙面面积
 */
@property (copy, nonatomic) NSString *wallArea;
/**
 *  项模型
 */
@property (strong, nonatomic) NSMutableArray<BLRJCalculatortempletModelAllCalculatorTypes *> *items;

@end
