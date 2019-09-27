//
//  GoodsDetailEnterShopCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsDetailEnterShopCell.h"

@implementation GoodsDetailEnterShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
    self.nameLabel.text = model.companyName;
//    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@", ];
    self.addressLabel.text = model.companyAddress;
}

@end
