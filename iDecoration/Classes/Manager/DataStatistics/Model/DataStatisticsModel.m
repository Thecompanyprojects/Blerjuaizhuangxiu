//
//  DataStatisticsModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DataStatisticsModel.h"

static NSArray *_arrayTop;
static NSArray *_arrayTitle;

@implementation DataStatisticsModel

+ (NSArray *)arrayTop {
    return @[@"企业", @"工地", @"计算器", @"商品", @"美文", @"活动"];
}

+ (NSArray *)arrayTitle {
    return @[@"浏览量", @"收藏", @"分享", @"预约量"];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[DataStatisticsModel class], @"valuelist":[DataStatisticsModel class], @"valueList":[DataStatisticsModel class]};
}

@end
