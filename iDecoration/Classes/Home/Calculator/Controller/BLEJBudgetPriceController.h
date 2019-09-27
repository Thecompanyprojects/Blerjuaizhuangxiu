//
//  BLEJBudgetPriceController.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@class ZCHCalculatorSimpleOfferModel;

@interface BLEJBudgetPriceController : SNViewController

// 卧室数量
@property (copy, nonatomic) NSString *bedroomNum;
// 卫生间数量
@property (copy, nonatomic) NSString *bathroomNum;
// 客厅的数量
@property (copy, nonatomic) NSString *hallNum;
// 阳台数量
@property (copy, nonatomic) NSString *balconyNum;
// 餐厅的数量
@property (copy, nonatomic) NSString *diningRoomNum;
// 厨房数量
@property (copy, nonatomic) NSString *kitchenNum;

// 房子面积
@property (copy, nonatomic) NSString *houseArea;

// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
// 基础模板中的其他信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorModel;

// 简装模型
@property (strong, nonatomic) ZCHCalculatorSimpleOfferModel *calculatorTotalModel;

// 精装模型
@property (strong, nonatomic) ZCHCalculatorSimpleOfferModel *calculatorRefineModel;

@end
