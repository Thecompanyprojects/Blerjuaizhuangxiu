//
//  HomeClassificationDetailTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "HomeClassificationDetailTableViewCell.h"

@implementation HomeClassificationDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"HomeClassificationDetailTableViewCell";
    HomeClassificationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)selectedCell:(BOOL)isSelected {
    if (isSelected) {
        self.viewSelected.hidden = false;
        self.labelTitle.backgroundColor = [UIColor colorWithRed:0.99 green:0.98 blue:0.98 alpha:1.00];
        [self.labelTitle setTextColor:[UIColor blackColor]];
    }else{
        self.viewSelected.hidden = true;
        self.labelTitle.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
        [self.labelTitle setTextColor:[UIColor hexStringToColor:@"8C8D8E"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
