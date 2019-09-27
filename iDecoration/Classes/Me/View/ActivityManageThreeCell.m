//
//  ActivityManageThreeCell.m
//  iDecoration
//
//  Created by sty on 2017/10/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivityManageThreeCell.h"

@implementation ActivityManageThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    if (self.colseActBlock) {
        self.colseActBlock();
    }
}

- (IBAction)checkDetailBtnClick:(UIButton *)sender {
    if (self.lookActBlock) {
        self.lookActBlock();
    }
}

- (IBAction)rePublicBtnClick:(UIButton *)sender {
    if (self.republicActBlock) {
        self.republicActBlock();
    }
}
@end
