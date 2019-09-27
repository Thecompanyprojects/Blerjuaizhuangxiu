//
//  JobNameTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/2/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "JobNameTableViewCell.h"

@implementation JobNameTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTitleLabel:)];
    self.titleLabel.userInteractionEnabled = YES;
    [self.titleLabel addGestureRecognizer:tap];
}

- (IBAction)didClickSelectBtn:(UIButton *)sender {
    
    if (btn) {
        btn.selected = NO;
    }
    sender.selected = YES;
    btn = sender;
    if ([self.delegate respondsToSelector:@selector(didClickSelectedBtn:withIndexpath:)]) {
        
        [self.delegate didClickSelectedBtn:sender withIndexpath:self.indexPath];
    }
}

- (void)didClickTitleLabel:(UITapGestureRecognizer *)tap {
    
    [self didClickSelectBtn:self.selectBtn];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
