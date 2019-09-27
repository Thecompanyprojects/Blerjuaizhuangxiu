//
//  ChangeLogoTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/2/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ChangeLogoTableViewCell.h"

@implementation ChangeLogoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    
    [self.LogoImageView addGestureRecognizer:tap];
    
    [self.publicBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
    
    [self.publicBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [self.publicBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 90, 0, -90)];
    
}

-(void)tap:(UITapGestureRecognizer*)sender{
    
    if (self.changeLogoBlock) {
        self.changeLogoBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)publicBtnClick:(UIButton *)sender {
    if (self.changePublicTag) {
        self.changePublicTag();
    }
}
@end
