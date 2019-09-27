//
//  BLEJBudgetPriceHeaderCell.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLEJBudgetPriceHeaderCell : UITableViewCell

// 厅
@property (copy, nonatomic) NSString *hallMoney;
// 卧室
@property (copy, nonatomic) NSString *bedroomMoney;
// 厨房
@property (copy, nonatomic) NSString *kitchenMoney;
// 卫生间
@property (copy, nonatomic) NSString *bathroomMoney;
// 其他费用
@property (copy, nonatomic) NSString *elseMoney;
// 阳台
@property (copy, nonatomic) NSString *balconyMoney;
// 管理费用
@property (copy, nonatomic) NSString *manageMoney;
// 总费用
@property (copy, nonatomic) NSString *totalMoney;
// 餐厅
@property (copy, nonatomic) NSString *diningMoney;

@end
