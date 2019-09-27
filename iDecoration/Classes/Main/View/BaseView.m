//
//  BaseView.m
//  iDecoration
//
//  Created by zuxi li on 2018/3/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.backgroundColor = [UIColor whiteColor];
}

@end
