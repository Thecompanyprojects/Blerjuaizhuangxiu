//
//  ZCHSearchCooperateModel.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSearchCooperateModel.h"
#import "ZCHCooperateListModel.h"

@implementation ZCHSearchCooperateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"companyList" : [ZCHCooperateListModel class]
             };
}

@end
