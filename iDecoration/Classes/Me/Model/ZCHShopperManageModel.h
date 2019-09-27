//
//  ZCHShopperManageModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHShopperManageModel : NSObject

/**
 *  类型名称
 */
@property (copy, nonatomic) NSString *typeName;
/**
 *  商铺logo
 */
@property (copy, nonatomic) NSString *merchantLogo;
/**
 *  会员结束天数（天数>=0时禁止删除）
 */
@property (copy, nonatomic) NSString *times;
/**
 *  商铺名称
 */
@property (copy, nonatomic) NSString *merchantName;
/**
 *  会员结束时间
 */
@property (copy, nonatomic) NSString *endTime;
/**
 *  关联Id
 */
@property (copy, nonatomic) NSString *relationId;
/**
 *  商铺Id
 */
@property (copy, nonatomic) NSString *merchantId;
@end
