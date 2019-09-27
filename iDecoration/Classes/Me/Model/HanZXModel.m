//
//  HanZXModel.m
//  iDecoration
//
//  Created by RealSeven on 17/3/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "HanZXModel.h"

@implementation HanZXModel

/*!
 *  1.该方法是 `字典里的属性Key` 和 `要转化为模型里的属性名` 不一样 而重写的
 *  前：模型的属性   后：字典里的属性
 */

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"hanId":@"id"};
}


- (void)setDingdate:(NSString *)dingdate {
    NSArray *dateArr = [dingdate componentsSeparatedByString:@"."];
    _dingdate = dateArr[0];
}

- (void)setAddTime:(NSString *)addTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:addTime.longLongValue/1000.0];
    NSString *currentTime = [formatter stringFromDate:date];
    _addTime = currentTime;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imgList": [ImageObject class]};
}
@end

@implementation ImageObject

@end
