//
//  ZCHSimpleSettingRoomModel.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSimpleSettingRoomModel.h"

@implementation ZCHSimpleSettingRoomModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"items" : [ZCHSimpleSettingRoomDetailModel class]
            };
}

@end
