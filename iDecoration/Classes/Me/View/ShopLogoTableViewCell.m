//
//  ShopLogoTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 2017/3/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopLogoTableViewCell.h"

@implementation ShopLogoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//开通会员
- (IBAction)openClick:(id)sender {
    
    if (self.openBlock) {
        self.openBlock();
    }
}

//会员详情
- (IBAction)detailClick:(id)sender {
    if (self.detailBlock) {
        self.detailBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
