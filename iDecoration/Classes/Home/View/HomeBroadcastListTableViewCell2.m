//
//  HomeBroadcastListTableViewCell2.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/14.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "HomeBroadcastListTableViewCell2.h"

@implementation HomeBroadcastListTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"HomeBroadcastListTableViewCell2";
    HomeBroadcastListTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
