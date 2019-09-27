//
//  WorkTypeModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "WorkTypeModel.h"

@implementation WorkTypeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children" : [WorkTypeModel class],
             @"list" : [WorkTypeModel class]};
}
@end
