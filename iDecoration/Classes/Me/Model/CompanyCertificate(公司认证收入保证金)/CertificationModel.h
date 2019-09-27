//
//  CertificationModel.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CertificateStatus) {
    CertificateStatusUnPay = 0, // 未支付
    CertificateStatusUnderway, // 认证中
    CertificateStatusSuccess, // 认证通过
    CertificateStatusFailure, // 认证失败
    CertificateStatusTimeOut, // 认证过期
    CertificateStatusUnknown, // 未认证过
};

@interface CertificationModel : NSObject
// 认证id
@property(nonatomic, assign) NSInteger authenticationId;
@property (nonatomic, copy) NSString *companyName; // 公司名称
@property (nonatomic, copy) NSString *regCode; // 工商号
@property (nonatomic, copy) NSString *personName; // 法人名称
@property (nonatomic, copy) NSString *licenseImg; // 营业执照
// 认证状态（0：未交认证费，1：待认证，2：认证通过，3：认证不通过,4:认证已过期）
@property(nonatomic, assign) CertificateStatus status; // 认证状态
@property(nonatomic, assign) NSInteger companyId; // 认证公司Id
@property(nonatomic, assign) NSInteger agencysId; // 认证人id
@property (nonatomic, copy) NSString *reason; // 认证不通过原因（保留字段）
@property (nonatomic, assign) double costTime; // 缴纳认证费用时间
@property (nonatomic, assign) double addTime; // 提交认证时间
@property (nonatomic, assign) double adoptTime; // 认证通过时间
@property (nonatomic, assign) double overdueDate; // 认证过期时间
@property (nonatomic, assign) double auMonth; // 认证缴费距今几月
@property (nonatomic, assign) double auYear; // 认证通过距今几年


@end
