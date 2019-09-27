//
//  ZCHCalculatorSimpleOfferModel.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCalculatorSimpleOfferModel.h"

@implementation ZCHCalculatorSimpleOfferModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"roomList" : [ZCHCalculatorRoomListModel class]
             };
}

@end
