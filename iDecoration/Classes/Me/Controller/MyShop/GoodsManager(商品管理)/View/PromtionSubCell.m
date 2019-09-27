//
//  PromtionSubCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "PromtionSubCell.h"

@implementation PromtionSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.selectGoodsBtn.layer.cornerRadius = 4;
    self.selectGoodsBtn.layer.borderWidth = 1;
    self.selectGoodsBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.selectGoodsBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
