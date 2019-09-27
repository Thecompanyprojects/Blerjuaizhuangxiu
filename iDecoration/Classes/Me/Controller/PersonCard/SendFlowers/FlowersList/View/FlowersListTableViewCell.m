//
//  FlowersListTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/18.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "FlowersListTableViewCell.h"
#import "FlowersListModel.h"

@implementation FlowersListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageViewIcon.layer.masksToBounds = true;
    self.imageViewIcon.layer.cornerRadius = 20.0f;
    [self.buttonStory addTarget:self action:@selector(didTouchButton:) forControlEvents:(UIControlEventTouchUpInside)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchIcon)];
    [self.imageViewIcon addGestureRecognizer:tap];
    self.imageViewIcon.userInteractionEnabled = true;
}

- (void)setModel:(FlowersListModel *)model {
    self.buttonStory.userInteractionEnabled = true;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.createDate doubleValue]/1000.0];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    self.labelDate.text = dateStr;
    self.labelTitle.text = model.trueName;
    self.labelDetail.text = model.title;
    [self.imageViewIcon sd_setImageWithURL:model.photo placeholderImage:[UIImage imageNamed:@"pic_touxiang2"]];
    if (model.type || model.story.length || model.title.length) {
        [self.buttonStory setImage:[UIImage imageNamed:@"img_small_xianhua_hongrenguan"] forState:(UIControlStateNormal)];
    }else{
        [self.buttonStory setImage:[UIImage imageNamed:@"icon_xianhua"] forState:(UIControlStateNormal)];
    }
    if (model.story.length) {
        self.buttonStory.userInteractionEnabled = true;
        [self.buttonStory setImage:[UIImage imageNamed:@"btn_gushi"] forState:(UIControlStateNormal)];
    }else
        self.buttonStory.userInteractionEnabled = false;
}

- (void)didTouchIcon {
    if (self.blockDidTouchIcon) {
        self.blockDidTouchIcon();
    }
}

- (void)didTouchButton:(UIButton *)sender {
    if (self.blockDidTouchButton) {
        self.blockDidTouchButton();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index {
    NSString *ID = [NSString stringWithFormat:@"FlowersListTableViewCell%ld",(long)index];
    FlowersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FlowersListTableViewCell" owner:self options:nil][index];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
