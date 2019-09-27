//
//  VIPExperienceModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/22.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubsidiaryModel.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPExperienceModel : SubsidiaryModel
+ (void)getCompanyAddressWithModel:(VIPExperienceModel *)model;
/**
 basicTitle
 */
//@property (strong, nonatomic) NSMutableArray *arrayBasicTitle;
//
///**
//
// */
//@property (strong, nonatomic) NSMutableArray *arrayBasicTitleInShow;
//
///**
//
// */
//@property (strong, nonatomic) NSMutableArray *arrayBasicInShow;
//
///**
// basicValue
// */
//@property (strong, nonatomic) NSMutableArray *arrayBasic;

///**
// 广告上
// */
//@property (strong, nonatomic) NSMutableArray *arrayADTop;
//
///**
// 广告下
// */
//@property (strong, nonatomic) NSMutableArray *arrayADBottom;

/**
 品牌LogoURL
 */
//@property (strong, nonatomic) NSURL *companyLogo;

/**
 imageLogo
 */
//@property (strong, nonatomic) UIImage *imageLogo;
//
///**
// 品牌名称
// */
//@property (strong, nonatomic) NSString *companyName;
//
///**
// 类别ID
// */
//@property (strong, nonatomic) NSString *companyType;
//
///**
// 类别string
// */
//@property (strong, nonatomic) NSString *typeName;
//
///**
// 服务范围
// */
//@property (strong, nonatomic) NSString *serviceScope;
//
///**
// 座机
// */
//@property (strong, nonatomic) NSString *companyLandline;
//
///**
// 地址
// */
//@property (strong, nonatomic) NSString *companyAddress;

/**
 详细地址
 */
//@property (strong, nonatomic) NSString *addressDetail;

///**
// 业务经理电话
// */
//@property (strong, nonatomic) NSString *companyPhone;
//
///**
// 邮箱
// */
//@property (strong, nonatomic) NSString *companyEmail;
//
///**
// 网址
// */
//@property (strong, nonatomic) NSString *URL;
//
///**
// 简介
// */
//@property (strong, nonatomic) NSString *companyIntroduction;
//
///**
// 纬度
// */
//@property (strong, nonatomic) NSString *longitude;

/**
 经度
 */
//@property (strong, nonatomic) NSString *lantitude;

//
///**
// 经度
// */
//@property (strong, nonatomic) NSString *latitude;
//
///**
// 判断是否为公司还是商铺
// */
//@property (assign, nonatomic) BOOL isCompany;
//
///**
// 装修区域
// */
//@property (strong, nonatomic) NSArray *areaList;
//
//
///**
// 省编号
// */
//@property (strong, nonatomic) NSString *companyProvince;
//
///**
// 市编号
// */
//@property (strong, nonatomic) NSString *companyCity;
//
///**
// g国家编号
// */
//@property (strong, nonatomic) NSString *companyCounty;
//
///**
// 公司网址
// */
//@property (strong, nonatomic) NSString *companyUrl;
//
///**
// 公司微信
// */
//@property (strong, nonatomic) NSString *companyWx;
//
///**
// 公ID
// */
//@property (strong, nonatomic) NSString *companyId;
//
///**
// 114是否可查
// */
//@property (strong, nonatomic) NSString *seeFlag;
@end

NS_ASSUME_NONNULL_END
