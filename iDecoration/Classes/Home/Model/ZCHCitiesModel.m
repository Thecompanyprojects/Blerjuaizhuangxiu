//
//  ZCHCitiesModel.m
//  iDecoration
//
//  Created by 赵春浩 on 17/9/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCitiesModel.h"
#import "ZCHCityModel.h"

@implementation ZCHCitiesModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"citys" : [ZCHCityModel class]
             };
}

@end
