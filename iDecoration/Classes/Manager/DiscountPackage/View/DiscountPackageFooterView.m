//
//  DiscountPackageFooterView.m
//  iDecoration
//
//  Created by 张毅成 on 2018/7/26.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "DiscountPackageFooterView.h"

@implementation DiscountPackageFooterView

- (void)drawRect:(CGRect)rect {
    self.height = 200;
}

- (IBAction)didTouchButton:(UIButton *)sender {
    if (self.blockDidTouchButton) {
        self.blockDidTouchButton(sender.tag);
    }
}

@end
