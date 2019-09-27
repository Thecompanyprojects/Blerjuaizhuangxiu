//
//  ZCHUploadCooperateCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHUploadCooperateCell.h"

@implementation ZCHUploadCooperateCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.layer.masksToBounds = YES;
    self.imageV.clipsToBounds = YES;
}

- (void)prepareForReuse {
    
    [self.imageV sd_cancelCurrentImageLoad];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
