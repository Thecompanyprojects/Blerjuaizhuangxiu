//
//  GoodsDetailModel.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsDetailModel.h"
#import "GoodsListModel.h"

@implementation GoodsDetailModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"goodsID":@"id"};
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [List class], @"activityList" : [ActivityListModel class],@"standardList" : [GoodsParamterModel class],@"serviceList" : [GoodsParamterModel class],@"priceTypeList" : [GoodsPriceModel class] };
}


@end

@implementation List

@end


@implementation CommmentModel

@end 
