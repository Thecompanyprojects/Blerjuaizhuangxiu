//
//  QrCodeCell.m
//  iDecoration
//
//  Created by sty on 2018/1/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "QrCodeCell.h"

@implementation QrCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
