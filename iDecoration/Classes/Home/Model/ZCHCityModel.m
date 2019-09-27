//
//  ZCHCityModel.m
//  iDecoration
//
//  Created by 赵春浩 on 17/9/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCityModel.h"

@implementation ZCHCityModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.pid forKey:@"pid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.provinceId forKey:@"provinceId"];
    [aCoder encodeObject:self.countyId forKey:@"countyId"];
}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.pid = [aDecoder decodeObjectForKey:@"pid"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.provinceId = [aDecoder decodeObjectForKey:@"provinceId"];
        self.countyId = [aDecoder decodeObjectForKey:@"countyId"];
    }
    
    return self;
}


/*!
 *  1.该方法是 `字典里的属性Key` 和 `要转化为模型里的属性名` 不一样 而重写的
 *  前：模型的属性   后：字典里的属性
 */

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"cityId" : @"id"};
}

@end
