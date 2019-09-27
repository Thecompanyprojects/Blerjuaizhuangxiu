//
//  CelebrityInterviewsTypeSelectedTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/20.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "CelebrityInterviewsTypeSelectedTableViewCell.h"

@implementation CelebrityInterviewsTypeSelectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewLine.hidden = true;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CelebrityInterviewsTypeSelectedTableViewCell";
    CelebrityInterviewsTypeSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.viewLine.hidden = false;
//    [self setBackgroundColor:[UIColor hexStringToColor:@"f2f2f2"]];
}

@end
