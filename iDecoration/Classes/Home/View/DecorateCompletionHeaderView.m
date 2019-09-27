//
//  DecorateCompletionHeaderView.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorateCompletionHeaderView.h"

@implementation DecorateCompletionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shareButton.backgroundColor = kMainThemeColor;
    self.shareButton.layer.cornerRadius = 6;
    
}
- (IBAction)shareAction:(id)sender {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

@end
