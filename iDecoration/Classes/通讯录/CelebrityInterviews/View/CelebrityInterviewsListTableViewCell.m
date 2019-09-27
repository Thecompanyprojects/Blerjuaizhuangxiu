//
//  CelebrityInterviewsListTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/19.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "CelebrityInterviewsListTableViewCell.h"

@implementation CelebrityInterviewsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.isListView) {
        [self.arrayImageViewLayout enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLayoutConstraint *layout = obj;
            layout.constant = 15;
        }];
        [self layoutIfNeeded];
    }
}

- (IBAction)didTouchButtonPlay:(UIButton *)sender {
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index {
    NSString *ID = [NSString stringWithFormat:@"CelebrityInterviewsListTableViewCell%ld",(long)index];
    CelebrityInterviewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CelebrityInterviewsListTableViewCell" owner:self options:nil][index];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CelebrityInterviewsListTableViewCell";
    CelebrityInterviewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (IBAction)didTouchButtonLike:(UIButton *)sender {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
