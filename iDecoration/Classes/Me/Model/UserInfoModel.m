//
//  UserInfoModel.m
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UserInfoModel.h"
#import "WorkTypeModel.h"
@implementation UserInfoModel

- (NSString *)roleType {
    __block NSString *string = @"";
    WorkTypeModel *model = [[CacheData sharedInstance] objectForKey:KRoleTypeList];
    [model.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WorkTypeModel *m = obj;
        NSArray *ar = m.children;
        [ar enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WorkTypeModel *mm = obj;
            if (self.roleTypeId == [mm.jobId integerValue]) {
                string = mm.name;
            }
        }];
    }];
    return string;
}

@end
