//
//  incomelistModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface incomelistModel : NSObject
@property (nonatomic,copy) NSString *incomeId;//收入明细id
@property (nonatomic,copy) NSString *agencyId;//人员id
@property (nonatomic,copy) NSString *incomeMoney;//收入金额
@property (nonatomic,copy) NSString *companyId;//来自主动收入的商家id
@property (nonatomic,copy) NSString *downName;//来自被动收入的下级分销员的名字
@property (nonatomic,copy) NSString *agencyType;//人员类型（0.分销员1.对接人）
@property (nonatomic,copy) NSString *incomeTime;//收入时间
@property (nonatomic,copy) NSString *incomeType;//收入类型(0.主动收入1.被动收入3.对接人查询团队收入)
@property (nonatomic,copy) NSString *companyName;//公司名称

@end

