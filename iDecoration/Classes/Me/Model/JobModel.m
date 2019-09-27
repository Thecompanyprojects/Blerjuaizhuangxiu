//
//  JobModel.m
//  iDecoration
//
//  Created by RealSeven on 17/2/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "JobModel.h"

@implementation JobModel

/*!
 *  1.该方法是 `字典里的属性Key` 和 `要转化为模型里的属性名` 不一样 而重写的
 *  前：模型的属性   后：字典里的属性
 */

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"jobId":@"id"};
}


@end
