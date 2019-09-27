//
//  ZCHCalculatorRoomListModel.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCalculatorRoomListModel.h"

@implementation ZCHCalculatorRoomListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"items" : [BLRJCalculatortempletModelAllCalculatorTypes class]
             };
}

@end
