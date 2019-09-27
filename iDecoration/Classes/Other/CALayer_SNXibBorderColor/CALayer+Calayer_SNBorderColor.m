//
//  CALayer+Calayer_SNBorderColor.m
//  MarketingMan
//
//  Created by RealSeven on 17/3/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CALayer+Calayer_SNBorderColor.h"
#import <UIKit/UIKit.h>

@implementation CALayer (Calayer_SNBorderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    
    self.borderColor = color.CGColor;
}

@end
