//
//  MessageNotiTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/3/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MessageNotiTableViewCell.h"

@implementation MessageNotiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)switchClick:(id)sender {
    
    if ([sender isOn]) {
        if (self.switchBlock) {
            self.switchBlock(YES);
        }
    }else{
        if (self.switchBlock) {
            self.switchBlock(NO);
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
