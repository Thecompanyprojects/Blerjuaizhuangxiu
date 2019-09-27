//
//  YGLCurrentPersonCompanyModel.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGLCurrentPersonCompanyModel : NSObject
/*
 "companyAddress": "北京市-东城区 北京市昌平区S216(京藏高速辅路)",
 "appVip": 1,
 "agencyJob": 1002,
 "conVip": 1,
 "customerVip": 1,
 "calVip": 1,
 "companyType": 1018,
 "companyLogo": "http://testimage.bilinerju.com/group1/M00/00/7F/rBHg0VpyxGeAatr1AAWjndV8nk4582.jpg",
 "companyId": 631,
 "recomendVip": 1,
 "companyName": "昌平测试分公司"
 */

@property (nonatomic, copy) NSString *companyAddress;      // 公司地址
@property (nonatomic, assign) NSInteger appVip;            // 企业会员（0:非会员,1:会员）
@property (nonatomic, assign) NSInteger agencyJob;         // 职位类型编码
@property (nonatomic, assign) NSInteger conVip;            // 日志会员
@property (nonatomic, assign) NSInteger customerVip;       // 定制会员
@property (nonatomic, assign) NSInteger calVip;            // 计算器会员
@property (nonatomic, assign) NSInteger companyType;       // 公司类型
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, assign) NSInteger companyId;         // 公司Id
@property (nonatomic, assign) NSInteger recomendVip;       // 1999会员  三个会员加成长计划
@property (nonatomic, copy) NSString *companyName;         // 公司名称
@property (nonatomic, assign) NSInteger implement; // 是否是执行经理  0 或 1
@end
