//
//  UILabel+ZCHCustomLabel.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UILabel+ZCHCustomLabel.h"

@implementation UILabel (ZCHCustomLabel)

+ (void)load {
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder *)aDecode{
    
    [self myInitWithCoder:aDecode];
    if (self) {
        // 部分不想改变字体的 把tag值设置成555跳过
        if (self.tag == 555) {
            
            if (IPhone4) {
                self.font = [UIFont systemFontOfSize:12];
            } else if (IPhone5) {
                self.font = [UIFont systemFontOfSize:12];
            } else {
                self.font = [UIFont systemFontOfSize:15];
            }
        }
    }
    return self;
}


@end
