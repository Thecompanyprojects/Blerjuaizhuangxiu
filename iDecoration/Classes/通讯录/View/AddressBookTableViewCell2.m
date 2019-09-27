//
//  AddressBookTableViewCell2.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/6.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "AddressBookTableViewCell2.h"

@implementation AddressBookTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageViewIcon.layer.cornerRadius = 30.0f;
    self.imageViewIcon.layer.masksToBounds = true;
}

- (void)setModel:(GeniusSquareListModel *)model {
    [self.imageViewIcon sd_setImageWithURL:model.photo placeholderImage:nil];
    self.labelTitle.text = model.name;
    self.labelLeft.text = model.jobTypeName.length?[NSString stringWithFormat:@" %@ ",model.jobTypeName]:@"";
    self.labelRight.text = model.jobName.length?[NSString stringWithFormat:@" %@ ",model.jobName]:@"";
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"AddressBookTableViewCell2";
    AddressBookTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
