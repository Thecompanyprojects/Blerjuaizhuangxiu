//
//  GoodsParamterModel.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "GoodsParamterModel.h"

@implementation GoodsParamterModel

+ (instancetype)newModel {
    GoodsParamterModel *model = [GoodsParamterModel new];
    model.name = @"";
    model.describ = @"";
    return model;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"describ":@[@"standardContent",@"serviceContent"], @"name": @[@"standardName", @"serviceName"]};
}
@end
