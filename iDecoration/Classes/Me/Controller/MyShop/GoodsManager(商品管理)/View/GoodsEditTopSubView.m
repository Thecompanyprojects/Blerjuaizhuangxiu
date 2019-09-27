//
//  GoodsEditTopSubView.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsEditTopSubView.h"

@implementation GoodsEditTopSubView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type {
   self =  [self initWithFrame:frame];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self nameLabel];
        [self imageV];
        [self textField];
        [self lineView];
    }
    return self;
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
        _nameLabel.textColor = [UIColor darkGrayColor];
    }
    return _nameLabel;
}

- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
        [self addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(8, 13));
        }];
        _imageV.image = [UIImage imageNamed:@"common_arrow_btn"];
    }
    return _imageV;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(self.nameLabel.mas_right).equalTo(8);
            make.top.bottom.equalTo(0);
            make.right.equalTo(self.imageV.mas_left).equalTo(-8);
        }];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textColor = [UIColor darkGrayColor];
    }
    return _textField;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [UIView new];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(0.5);
        }];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

@end
