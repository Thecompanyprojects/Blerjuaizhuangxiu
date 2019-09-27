//
//  MyOrderModel.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

@property (nonatomic, copy) NSString *money; // 价格（为0时说明没有支付）
@property (nonatomic, copy) NSString *signUpTime; // 报名时间
@property (nonatomic, copy) NSString *designTitle; // 标题
@property (nonatomic, copy) NSString *signUpId; // 报名id
@property (nonatomic, copy) NSString *status; // 状态（0：未支付，1：待确认，2：已确认）
@property (nonatomic, copy) NSString *payWay; // 支付方式（价格为0是该参数不返）
@property (nonatomic, copy) NSString *payDate; // 支付时间（价格为0是该参数不返）
@property (nonatomic, copy) NSString *orderId; // 订单编号（价格为0是该参数不返）
@property (nonatomic, copy) NSString *userName; // 报名人信息
@property (nonatomic, copy) NSString *coverMap; // 封面如
@property (nonatomic, copy) NSString *userPhone; // 手机号
@property (nonatomic, copy) NSString *startTime; //活动开始时间
@end
