//
//  ZCHGoodsShowModel.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHGoodsShowModel.h"

@implementation ZCHGoodsShowModel

/*!
 *  1.该方法是 `字典里的属性Key` 和 `要转化为模型里的属性名` 不一样 而重写的
 *  前：模型的属性   后：字典里的属性
 */

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"goodsId":@"id"};
}

@end
