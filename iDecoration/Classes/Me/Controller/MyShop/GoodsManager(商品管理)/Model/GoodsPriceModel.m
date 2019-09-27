//
//  GoodsPriceModel.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "GoodsPriceModel.h"

@implementation GoodsPriceModel

+ (instancetype)newModel {
    GoodsPriceModel *model = [self new];
    model.name = @"";
    model.price = @"";
    model.unit = @"";
    model.num = @"";
    model.imageURL = @"";
    model.image = nil;
    
    return model;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"name":@"typeName", @"unit": @"typeUnit", @"price":@"typePrice", @"num": @"typeSum", @"imageURL": @"typeDisplay"};
}

@end
