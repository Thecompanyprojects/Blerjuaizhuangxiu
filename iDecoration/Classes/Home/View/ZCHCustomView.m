//
//  ZCHCustomView.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCustomView.h"

@implementation ZCHCustomView


- (void)setBorderColor:(UIColor *)borderColor {
    
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

@end
