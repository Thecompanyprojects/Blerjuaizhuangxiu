//
//  ConsImageCollectionViewCell.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ConsImageCollectionViewCell.h"

@implementation ConsImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.consImageView.layer.cornerRadius = 5;
    self.consImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.consImageView.layer.borderWidth = 0.5;
}

@end
