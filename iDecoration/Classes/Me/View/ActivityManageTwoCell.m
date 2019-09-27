//
//  ActivityManageTwoCell.m
//  iDecoration
//
//  Created by sty on 2017/10/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivityManageTwoCell.h"

@implementation ActivityManageTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)EditBtnClick:(UIButton *)sender {
    if (self.editActBlock) {
        self.editActBlock();
    }
}

- (IBAction)manageBtnClick:(UIButton *)sender {
    if (self.manageActBlock) {
        self.manageActBlock();
    }
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    if (self.shareActBlock) {
        self.shareActBlock();
    }
}


@end
