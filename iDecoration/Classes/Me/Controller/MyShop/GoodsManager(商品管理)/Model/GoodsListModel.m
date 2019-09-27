//
//  GoodsListModel.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsListModel.h"

@implementation GoodsListModel

/*!
 *  1.该方法是 `字典里的属性Key` 和 `要转化为模型里的属性名` 不一样 而重写的
 *  前：模型的属性   后：字典里的属性
 */

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"goodsID":@"id", @"display": @"faceImg"};
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"activityList" : [ActivityListModel class]};
}


@end


@implementation ActivityListModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"activityID":@"id"};
}
@end
