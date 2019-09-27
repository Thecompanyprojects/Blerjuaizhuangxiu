//
//  SendFlowersModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SendFlowersModel.h"

@implementation SendFlowersModel

+ (instancetype)sharedInstance {
    static SendFlowersModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SendFlowersModel new];
    });
    return instance;
}

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
        [self.arrayImageIconName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SendFlowersModel *model = [SendFlowersModel new];
            model.imageIcon = [UIImage imageNamed:self.arrayImageIconName[idx]];
            model.stringTitle = self.arrayStringTitle[idx];
            model.stringDetail = self.arrayStringDetail[idx];
            model.isSelected = false;
            model.stringPrice = self.arrayStringPrice[idx];
            if (idx == 0) {
                model.isSelected = true;
            }
            [_arrayData addObject:model];
        }];
    }
    return _arrayData;
}

- (NSArray *)arrayStringTitle {
    return @[@"一朵", @"一束"];
}

- (NSArray *)arrayStringDetail {
    return @[@"", @"(12朵)"];
}

- (NSArray *)arrayImageIconName {
    return @[@"icon_xianhua", @"icon_yishuhua"];
}

- (NSArray *)arrayStringPrice {
    return @[@"¥1.0", @"优惠价¥8.0"];
}
@end
