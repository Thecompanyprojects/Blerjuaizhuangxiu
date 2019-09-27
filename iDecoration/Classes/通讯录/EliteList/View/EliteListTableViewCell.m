//
//  EliteListTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EliteListTableViewCell.h"
#import "GeniusSquareListModel.h"

@implementation EliteListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EliteListTableViewCell";
    EliteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)setModel:(GeniusSquareListModel *)model {
    [self.imageViewIcon sd_setImageWithURL:model.photo placeholderImage:nil];
    self.labelCompany.text = model.companyName;
    self.labelName.text = model.name;
    self.labelLeft.text = model.jobTypeName.length?[NSString stringWithFormat:@" %@ ",model.jobTypeName]:@"";
    self.labelRight.text = model.jobName.length?[NSString stringWithFormat:@" %@ ",model.jobName]:@"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
