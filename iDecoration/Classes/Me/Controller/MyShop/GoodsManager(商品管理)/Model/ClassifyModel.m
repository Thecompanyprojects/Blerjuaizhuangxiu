//
//  ClassifyModel.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel

/*!
 *  1.该方法是 `字典里的属性Key` 和 `要转化为模型里的属性名` 不一样 而重写的
 *  前：模型的属性   后：字典里的属性
 */

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"categoryID":@"id"};
}


+ (instancetype)newModelWithID:(NSInteger)categoryID andCategoryName:(NSString *)categoryName {
    ClassifyModel *model = [self new];
    model.categoryID = categoryID;
    model.categoryName = categoryName;
    return model;
}

@end
