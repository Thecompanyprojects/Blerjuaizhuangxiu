//
//  ActivitySignUpSettingCell.m
//  iDecoration
//
//  Created by sty on 2017/10/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivitySignUpSettingCell.h"

@implementation ActivitySignUpSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.borderColor = Red_Color.CGColor;
    self.sureBtn.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(sender.tag);
    }
}
- (IBAction)sureBtnClick:(UIButton *)sender {
    if (self.sureBlock) {
        self.sureBlock(sender.tag);
    }
}
@end
