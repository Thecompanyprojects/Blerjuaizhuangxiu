//
//  HomeBroadcastListTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/9.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "HomeBroadcastListTableViewCell.h"

@implementation HomeBroadcastListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"HomeBroadcastListTableViewCell";
    HomeBroadcastListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
