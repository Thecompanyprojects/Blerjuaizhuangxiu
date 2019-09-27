//
//  EditShopLogoTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditShopLogoTableViewCell.h"

@implementation EditShopLogoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    
    self.logoImageView.userInteractionEnabled = YES;
    [self.logoImageView addGestureRecognizer:tap];
}

-(void)tap:(UITapGestureRecognizer*)sender{
    
    if (self.tapBlock) {
        self.tapBlock();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
