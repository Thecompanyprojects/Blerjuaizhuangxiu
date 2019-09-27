//
//  AddPromotionCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddPromotionCell.h"

@implementation AddPromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self nameLabel];
    [self textField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(16);
            make.width.equalTo(74);
        }];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(self.nameLabel.mas_right).equalTo(8);
            make.top.bottom.equalTo(0);
            make.right.equalTo(-8);
        }];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textColor = [UIColor blackColor];
    }
    return _textField;
}

@end
