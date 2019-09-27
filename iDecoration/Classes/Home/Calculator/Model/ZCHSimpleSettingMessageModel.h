//
//  ZCHSimpleSettingMessageModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHSimpleSettingMessageModel : NSObject

/**
 *  主键
 */
@property (copy, nonatomic) NSString *setId;
/**
 *  计算器类型
 */
@property (copy, nonatomic) NSString *setType;
/**
 *  0：没有设计费
 */
@property (copy, nonatomic) NSString *hasDesign;
/**
 *  套餐价格
 */
@property (copy, nonatomic) NSString *price;
/**
 *  0：不展示细节
 */
@property (copy, nonatomic) NSString *showDetail;
/**
 *  0：不收税费
 */
@property (copy, nonatomic) NSString *tax;
/**
 *  0：是否收取安装费
 */
@property (copy, nonatomic) NSString *inst;
/**
 *  0：安装费多少
 */
@property (copy, nonatomic) NSString * installationFee;

/**
 *  0：不使用套餐价格
 */
@property (copy, nonatomic) NSString *isPackage;
/**
 *  公司Id
 */
@property (copy, nonatomic) NSString *companyId;

@end
