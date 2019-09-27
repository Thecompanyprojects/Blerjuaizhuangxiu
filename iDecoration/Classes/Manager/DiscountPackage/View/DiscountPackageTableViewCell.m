//
//  DiscountPackageTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/7/24.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "DiscountPackageTableViewCell.h"

@implementation DiscountPackageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index {
    NSString *ID = [NSString stringWithFormat:@"DiscountPackageTableViewCell%ld",(long)index];
    DiscountPackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DiscountPackageTableViewCell" owner:self options:nil][index];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
