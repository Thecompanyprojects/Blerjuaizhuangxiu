//
//  ExcellentCaseTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/8/5.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "ExcellentCaseTableViewCell.h"

@implementation ExcellentCaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ExcellentCaseTableViewCell";
    ExcellentCaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
