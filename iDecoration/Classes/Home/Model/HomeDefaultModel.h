//
//  HomeDefaultModel.h
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseModel.h"

@interface HomeDefaultModel : HomeBaseModel

/**商铺id*/
@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *shopID;
// 设计师统计
@property (nonatomic, copy) NSString *designerTotal;
// 浏览数
@property (nonatomic, copy) NSString *browse;
// logo
@property (nonatomic, copy) NSString *typeLogo;
// 是否开通vip (1表示开通)
@property (nonatomic, copy) NSString *vipState;
// 电话
@property (nonatomic, copy) NSString *landline;
// 工长统计
@property (nonatomic, copy) NSString *foremanTotal;
// 是否是114可查
@property (nonatomic, copy) NSString *seeFlag;
// 监理统计
@property (nonatomic, copy) NSString *supervisorTotal;
// 1 表示公司  2 表示店铺
@property (nonatomic, copy) NSString *commodityType;
// 名称
@property (nonatomic, copy) NSString *typeName;
// 案例数  已交工工地数
@property (nonatomic, copy) NSString *caseTotla;
//未交工工地数量
@property (nonatomic, copy) NSString *constructionTotal;
// 商家商品量
@property (nonatomic, copy) NSString *total;
// 展现量
@property (copy, nonatomic) NSString *displayNumbers;

// 好评数
@property (nonatomic, copy) NSString *praiseTotal;
// 
@property (nonatomic, copy) NSString *address;

// 公司简介
@property (nonatomic, copy) NSString *companyIntroduction;

// 收藏的店铺或公司ID     collectionId    已收藏 > 0 ，  未收藏0   collectionId
@property (nonatomic, assign) NSInteger collectionId;
// 位置信息
@property (copy, nonatomic) NSString *locationStr;
// 收藏量
@property (copy, nonatomic) NSString *collectionNumbers;

@property (copy, nonatomic) NSString *typeNo;//公司的类型
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *merchantId;//
@property (copy, nonatomic) NSString *merchantName;
@property (copy, nonatomic) NSString *countyName;

// 权重
@property (nonatomic, strong) NSString *companyWeight;
// 1是0不是 钻石会员
@property (nonatomic, strong) NSString *recommendVip;
// 认证状态（0：未交认证费，1：待认证，2：已认证，3：认证失败，4：认证过期）
@property (nonatomic, copy) NSString *status;
//非会员美文Id                          noVipDesignId
@property (nonatomic, copy) NSString *noVipDesignId;

/**

 */
@property (copy, nonatomic) NSString *companyLogo;
@property (strong, nonatomic) NSString *appVip;
@property (strong, nonatomic) NSString *calculatorType;
@property (strong, nonatomic) NSString *companyId;
@property (copy, nonatomic) NSString *companyLandline;
@property (copy, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *companyPhone;
@property (strong, nonatomic) NSString *companyType;
@property (copy, nonatomic) NSString *companyAddress;
@property (strong, nonatomic) NSString *conVip;
@property (strong, nonatomic) NSString *distince;
@property (strong, nonatomic) NSString *flowers;
@property (strong, nonatomic) NSString *likeNumbers;
@property (strong, nonatomic) NSString *longitude;
@end
