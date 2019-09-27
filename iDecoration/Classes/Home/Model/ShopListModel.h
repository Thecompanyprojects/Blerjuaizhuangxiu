//
//  ShopListModel.h
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseModel.h"
@interface ShopListModel : HomeBaseModel

@property (nonatomic, copy) NSString * provinceName;
@property (nonatomic, copy) NSString * provinceId;
@property (nonatomic, copy) NSString *merchantLogo;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *merchantWx;
@property (nonatomic, copy) NSString * companyTotal;
@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * relId;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString * vipEndDate;
@property (nonatomic, copy) NSString * merchantId;
@property (nonatomic, copy) NSString * vipDay;
@property (nonatomic, copy) NSString * typeNo;
@property (nonatomic, copy) NSString * relType;
@property (nonatomic, copy) NSString *merchantPhone;
@property (nonatomic, copy) NSString * typeName;
@property (nonatomic, copy) NSString * browse;
@property (nonatomic, copy) NSString *merchantLandline;
@property (nonatomic, copy) NSString * createPersonId;
@property (nonatomic, copy) NSString * cityId;
@property (nonatomic, copy) NSString * cityName;
@property (nonatomic, copy) NSString * vipState;
@property (nonatomic, copy) NSString * trueName;
@property (nonatomic, copy) NSString *merchantNameInitial;
@property (nonatomic, copy) NSString * countyName;
@property (nonatomic, copy) NSString * countyId;
@property (nonatomic, copy) NSString * vipStartDate;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * createDatetime;
@property (nonatomic, copy) NSString * companyName;
@property (nonatomic, copy) NSString * seeFlag;

//collectionId   是否收藏   是为收藏id  否  等于0
@property (nonatomic, assign) NSInteger collectionId;

// companyIntroduction  店铺简介
@property (nonatomic, copy) NSString *companyIntroduction;

// 收藏量
@property (copy, nonatomic) NSString *collectionNumbers;

// 案例数  已交工工地数
@property (nonatomic, copy) NSString *caseTotla;
//未交工工地数量
@property (nonatomic, copy) NSString *constructionTotal;
// 商家商品量
@property (nonatomic, copy) NSString *total;
// 展现量
@property (copy, nonatomic) NSString *displayNumbers;
// 认证状态（0：未交认证费，1：待认证，2：已认证，3：认证失败，4：认证过期）
@property (nonatomic, copy) NSString *status;
// 1是0不是 钻石会员
@property (nonatomic, strong) NSString *recommendVip;
//非会员美文Id                          noVipDesignId
@property (nonatomic, copy) NSString *noVipDesignId;

@property (nonatomic, copy) NSString *type;

@end
