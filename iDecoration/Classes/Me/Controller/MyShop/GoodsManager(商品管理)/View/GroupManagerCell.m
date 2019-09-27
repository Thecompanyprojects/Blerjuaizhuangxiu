//
//  GroupManagerCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GroupManagerCell.h"

@implementation GroupManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(groupManagerCell:delegateActionAtIndex:)]) {
        [self.delegate groupManagerCell:self delegateActionAtIndex:self.indexPath];
    }
}
- (IBAction)moveUpAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(groupManagerCell:moveUpActionFromIndex:)]) {
        [self.delegate groupManagerCell:self moveUpActionFromIndex:self.indexPath];
    }
}
- (IBAction)moveDownAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(groupManagerCell:moveDownActionFromIndex:)]) {
        [self.delegate groupManagerCell:self moveDownActionFromIndex:self.indexPath];
    }
}


@end
