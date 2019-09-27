//
//  EnterTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/3/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EnterTableViewCell.h"

@implementation EnterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)enterClick:(id)sender {
    
  
    
    if (self.delegate  &&[self.delegate respondsToSelector:@selector(enterChat)]) {
        [self.delegate  enterChat];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
