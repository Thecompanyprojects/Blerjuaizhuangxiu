//
//  UserLogoTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/2/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UserLogoTableViewCell.h"

@implementation UserLogoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    self.backgroundColor = White_Color;
    [self.LogoImageView addGestureRecognizer:tap];
    
    // 开通短息通按钮图上字下
//    CGFloat imageWith = self.vipButton.imageView.frame.size.width;
//    CGFloat imageHeight = self.vipButton.imageView.frame.size.height;
//    CGFloat labelWidth = 0.0;
//    CGFloat labelHeight = 0.0;
//    labelWidth = self.vipButton.titleLabel.intrinsicContentSize.width;
//    labelHeight = self.vipButton.titleLabel.intrinsicContentSize.height;
//    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
//    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
//    imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
//    labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
//    self.vipButton.titleEdgeInsets = labelEdgeInsets;
//    self.vipButton.imageEdgeInsets = imageEdgeInsets;
    
    
}
//登录注册按钮
- (IBAction)regAndLogClick:(id)sender {
    
    if (self.regAndLoginBlock) {
        self.regAndLoginBlock();
    }
}
// 号码通按钮
- (IBAction)vipButtonAction:(id)sender {
    if (self.vipActionBlock) {
        self.vipActionBlock();
    }
}

-(void)tapped:(UITapGestureRecognizer*)sender{
    
    if (self.logoBlock) {
        self.logoBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
