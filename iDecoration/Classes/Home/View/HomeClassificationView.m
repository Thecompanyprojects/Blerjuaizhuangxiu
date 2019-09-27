//
//  HomeClassificationView.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "HomeClassificationView.h"

@implementation HomeClassificationView

- (void)drawRect:(CGRect)rect {
    [self.arrayHeight enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint *height = obj;
        height.constant = IphoneX?:height.constant * Yrang;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.blockDidTouchView) {
        self.blockDidTouchView();
    }
}

@end
