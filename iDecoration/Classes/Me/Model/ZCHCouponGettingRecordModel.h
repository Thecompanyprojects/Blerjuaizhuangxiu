//
//  ZCHCouponGettingRecordModel.h
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHCouponGettingRecordModel : NSObject

//customerName true string
//startDate true string
//phone true string
//couponName true string
//couponNo true string
//endDate true string
//code true string
//companyName true string
//type true number
//couponId true number
//agencyId true number
//price true string
//merchandPhoto true string
//merchandName true string
//numbers true number
//createAgencyId true number
//receiveTime true number
//companyLogo true string
//exchangeAddress true string
//companyId


// 姓名
@property (nonatomic, copy) NSString *customerName;
// 手机号
@property (nonatomic, copy) NSString *phone;
// 领取时间
@property (nonatomic, copy) NSString *receiveTime;
// 验证码
@property (nonatomic, copy) NSString *code;
// 用户Id可能为0
@property (nonatomic, copy) NSString *agencyId;
// 代金券编号
@property (nonatomic, copy) NSString *couponNo;

@property (copy, nonatomic) NSString *giftName;


// 生效时间
@property (nonatomic, copy) NSString *startDate;
// 代金券名称
@property (nonatomic, copy) NSString *couponName;
// 失效时间
@property (nonatomic, copy) NSString *endDate;
// 公司名字
@property (nonatomic, copy) NSString *companyName;
// 代金券类型
@property (nonatomic, copy) NSString *type;
// 代金券Id
@property (nonatomic, copy) NSString *couponId;
// 代金券金额
@property (nonatomic, copy) NSString *price;
// 礼品券封面
@property (nonatomic, copy) NSString *merchandPhoto;
// 礼品券名称
@property (nonatomic, copy) NSString *merchandName;
// 数量
@property (nonatomic, copy) NSString *numbers;
// 创建人Id
@property (nonatomic, copy) NSString *createAgencyId;
// 公司logo
@property (nonatomic, copy) NSString *companyLogo;
// 兑换地址
@property (nonatomic, copy) NSString *exchangeAddress;
// 公司Id
@property (nonatomic, copy) NSString *companyId;

// 兑换码
@property (nonatomic, copy) NSString *receiveCode;
@end
