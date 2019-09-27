//
//  ZCHCustomButton.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCustomButton.h"

@implementation ZCHCustomButton

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    labelWidth = self.titleLabel.intrinsicContentSize.width;
    labelHeight = self.titleLabel.intrinsicContentSize.height;
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-20/2.0, 0, 0, -labelWidth);
    labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-20/2.0, 0);
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
