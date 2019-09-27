//
//  CompanyIncomeModel.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyIncomeModel : NSObject


@property (nonatomic, copy) NSString *userPhone; // 报名电话
@property (nonatomic, copy) NSString *money; // 金额
@property (nonatomic, copy) NSString *costName; // 费用名称
@property (nonatomic, copy) NSString *designTitle; // 标题
@property (nonatomic, copy) NSString *payWay; // 支付方式（0：支付宝，1：微信）
@property (nonatomic, copy) NSString *startTime; // 活动开始时间
@property (nonatomic, copy) NSString *payDate; // 支付时间
@property (nonatomic, copy) NSString *orderId; // 订单编号
@property (nonatomic, copy) NSString *trueName; // 姓名
@property (nonatomic, copy) NSString *withdrawalsYes; // 可提现金额
@property (nonatomic, copy) NSString *withdrawalsNo; // 锁定保证金金额

@property (nonatomic, copy) NSString *frozenActivityMoney; // 锁定保证金金额

@property (nonatomic, copy) NSString *coverMap; // 封面图

@end
