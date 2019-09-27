//
//  FlowersStoryDetailTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/18.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "FlowersStoryDetailTableViewCell.h"

@implementation FlowersStoryDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index {
    NSString *ID = [NSString stringWithFormat:@"FlowersStoryDetailTableViewCell%ld",(long)index];
    FlowersStoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FlowersStoryDetailTableViewCell" owner:self options:nil][index];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
