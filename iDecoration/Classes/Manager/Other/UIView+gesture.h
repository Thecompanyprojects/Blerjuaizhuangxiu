//
//  UIView+gesture.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/1.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (gesture)
- (void)setTapActionWithBlock:(void (^)(void))block;

- (void)setLongPressActionWithBlock:(void (^)(void))block;
@end
