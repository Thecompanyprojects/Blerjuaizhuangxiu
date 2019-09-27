//
//  CelebrityInterviewsTypeSelectedModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/20.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "CelebrityInterviewsTypeSelectedModel.h"

@implementation CelebrityInterviewsTypeSelectedModel

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
        NSArray *array = @[@"全部", @"视频专访", @"文章专访"];
        for (int i = 0; i < 3; i ++) {
            CelebrityInterviewsTypeSelectedModel *model = [CelebrityInterviewsTypeSelectedModel new];
            model.isSelected = false;
            model.title = array[i];
            [_arrayData addObject:model];
        }
    }
    return _arrayData;
}
@end
