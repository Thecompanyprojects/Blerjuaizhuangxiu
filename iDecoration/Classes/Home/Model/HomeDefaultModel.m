//
//  HomeDefaultModel.m
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "HomeDefaultModel.h"






@implementation HomeDefaultModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"shopID":@"id", @"constructionTotal": @[@"constructionTotal", @"constructionTotla"], @"vipState":@"appVip"};
}

@end
