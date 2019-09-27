//
//  HomeClassificationModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "HomeClassificationModel.h"

static NSArray *_arrayTitle;
static NSArray *_arrayIcon;
@implementation HomeClassificationModel
+ (NSArray *)arrayIcon {
    if (!_arrayIcon) {
        _arrayIcon = @[@"icon_big_ruanzhuangyingzhuang", @"icon_big_zhucaifucai", @"icon_big_jiajudianqi",
                       @"icon_big_peitaofuwu", @"icon_big_jiajushenghuo"];
    }
    return _arrayIcon;
}

+ (NSArray *)arrayTitle {
    if (!_arrayTitle) {
        _arrayTitle = @[@"硬装软装", @"主材辅材", @"家具电器", @"配套/服务", @"家居生活"];
    }
    return _arrayTitle;
}
@end
