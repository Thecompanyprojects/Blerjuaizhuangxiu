//
//  CompanyLogoTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/3/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CompanyLogoTableViewCell.h"

@implementation CompanyLogoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)modifyClick:(id)sender {
    
    if (self.modifyBlock) {
        self.modifyBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
