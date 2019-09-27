//
//  ZCHGoodsShowModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHGoodsShowModel : NSObject

/**
 *  商品id
 */
@property (copy, nonatomic) NSString *goodsId;
/**
 *  商品名称
 */
@property (copy, nonatomic) NSString *name;
/**
 *  商家id
 */
@property (copy, nonatomic) NSString *merchantId;
/**
 *  商品图片
 */
@property (copy, nonatomic) NSString *display;
/**
 *  商品价格
 */
@property (copy, nonatomic) NSString *price;
/**
 *  添加时间
 */
@property (copy, nonatomic) NSString *createDate;

@end
