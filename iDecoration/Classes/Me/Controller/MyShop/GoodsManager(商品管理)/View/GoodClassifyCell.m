//
//  GoodClassifyCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodClassifyCell.h"

@implementation GoodClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ClassifyModel *)model {
    _model = model;
    self.titleLabel.text = model.categoryName;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [_titleLabel setMinimumScaleFactor:10.0/14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}
@end
