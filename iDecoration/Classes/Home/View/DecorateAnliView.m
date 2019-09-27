//
//  DecorateAnliView.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorateAnliView.h"

@implementation DecorateAnliView


- (IBAction)buttonClick:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(self.index);
    }
}

@end
