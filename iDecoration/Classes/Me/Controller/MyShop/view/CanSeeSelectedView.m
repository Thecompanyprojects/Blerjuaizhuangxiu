//
//  CanSeeSelectedView.m
//  iDecoration
//
//  Created by zuxi li on 2017/8/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CanSeeSelectedView.h"

@implementation CanSeeSelectedView


- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    self.firstView.userInteractionEnabled = YES;
    self.firstView.tag = 1;
    [self.firstView addGestureRecognizer:tapGR1];
    
    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    self.secondView.userInteractionEnabled = YES;
    self.secondView.tag = 2;
    [self.secondView addGestureRecognizer:tapGR2];
    
    UITapGestureRecognizer *tapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    self.thirdView.userInteractionEnabled = YES;
    self.thirdView.tag = 3;
    [self.thirdView addGestureRecognizer:tapGR3];
    
    UITapGestureRecognizer *tapGR4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewTapGRAction:)];
    self.blackView.userInteractionEnabled = YES;
    self.blackView.tag = 4;
    [self.blackView addGestureRecognizer:tapGR4];
    
    self.thridImageView.image = [UIImage imageNamed:@"pitch"];
}


- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.thridImageView.image = [UIImage imageNamed:@"pitch0"];
    switch (selectedIndex) {
        case 1:
            self.firstImageView.image = [UIImage imageNamed:@"pitch"];
            break;
        case 2:
            self.secondImageView.image = [UIImage imageNamed:@"pitch"];
            break;
        case 3:
            self.thridImageView.image = [UIImage imageNamed:@"pitch"];
            break;
        default:
            self.thridImageView.image = [UIImage imageNamed:@"pitch"];
            break;
    }
    _selectedIndex = selectedIndex;
}

- (void)tapGRAction:(UITapGestureRecognizer *)tapGR {
    UIView *view = tapGR.view;
    NSInteger index = view.tag;
    NSString *title = @"";
    self.hidden = YES;
    self.firstImageView.image = [UIImage imageNamed:@"pitch0"];
    self.secondImageView.image = [UIImage imageNamed:@"pitch0"];
    self.thridImageView.image = [UIImage imageNamed:@"pitch0"];
    switch (index) {
        case 1:
            title = @"只显示在内网";
            self.firstImageView.image = [UIImage imageNamed:@"pitch"];
            break;
        case 2:
            title = @"只显示在外网";
            self.secondImageView.image = [UIImage imageNamed:@"pitch"];
            break;
        case 3:
            title = @"内外网全部显示";
            self.thridImageView.image = [UIImage imageNamed:@"pitch"];
            break;
        default:
            break;
    }
    if (self.selectedBlock) {
        self.selectedBlock(title, index);
    }
}


- (void)hideViewTapGRAction:(UITapGestureRecognizer *)tapGR {
    self.hidden = YES;
}

@end
