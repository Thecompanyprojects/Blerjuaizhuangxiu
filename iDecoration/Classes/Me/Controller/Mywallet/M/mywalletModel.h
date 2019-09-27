//
//  mywalletModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mywalletModel : NSObject
@property (nonatomic,copy) NSString *money;//金额
@property (nonatomic,copy) NSString *time;//时间
@property (nonatomic,copy) NSString *type;//类型 1：打赏2：提现
@property (nonatomic,copy) NSString *rewardkyMoney;//可提现金额
@end
