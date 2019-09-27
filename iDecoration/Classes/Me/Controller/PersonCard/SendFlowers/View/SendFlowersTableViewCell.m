//
//  SendFlowersTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SendFlowersTableViewCell.h"

@implementation SendFlowersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchImageViewIcon)];
    [self.imageViewIcon addGestureRecognizer:tap];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SendFlowersTableViewCell";
    SendFlowersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)didTouchImageViewIcon {
    if (self.blockDidTouchImageViewIcon) {
        self.blockDidTouchImageViewIcon();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
