//
//  CodeView.m
//  demo
//
//  Created by zuxi li on 2017/6/30.
//  Copyright © 2017年 zuxi li. All rights reserved.
//

#import "CodeView.h"

//#define MAS_SHORTHAND_GLOBALS
//#import <Masonry.h>
//// 屏幕宽高
//#define kSCREEN_HEIGHT      [UIScreen mainScreen].bounds.size.height
//#define kSCREEN_WIDTH       [UIScreen mainScreen].bounds.size.width
//// 以iphone6为原型做屏幕适配大小
//#define kSize(num) ([UIScreen mainScreen].bounds.size.width/375.0) * num
//


@interface CodeView()

@property (nonatomic, strong) UILabel *saveLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@end
@implementation CodeView

- (instancetype)init {
    if (self = [super init]) {
        [self labelView];
        [self typeLabel];
        [self areaLabel];
        [self companyNameLabel];
        [self imageView];
        [self QRCodeImageView];
        [self visitLabel];
        [self saveLabel];
        [self promptLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self labelView];
        [self typeLabel];
        [self areaLabel];
        [self companyNameLabel];
        [self imageView];
        [self QRCodeImageView];
        [self visitLabel];
        [self saveLabel];
        [self promptLabel];
        
    }
    return self;
}



- (UIView *)labelView {
    if (_labelView == nil) {
        _labelView = [UIView new];
        [self addSubview:_labelView];
        [_labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-kSCREEN_HEIGHT / 2.0);
            make.height.equalTo(62);
        }];
        _labelView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    }
    return _labelView;
}

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [UILabel new];
        [self.labelView addSubview:_typeLabel];
        _typeLabel.font = [UIFont systemFontOfSize:kSize(17)];
        _typeLabel.numberOfLines = 0;
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(12);
            make.top.equalTo(4);
            make.right.equalTo(-12);
            make.height.equalTo(30);
        }];
    }
    return _typeLabel;
}

- (UILabel *)areaLabel {
    if (_areaLabel == nil) {
        _areaLabel = [UILabel new];
        [self.labelView addSubview:_areaLabel];
        [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(12);
            make.top.equalTo(self.typeLabel.mas_bottom).equalTo(4);
            make.bottom.equalTo(-4);
            make.width.equalTo(kSCREEN_WIDTH/3.0 - 12);
            make.height.equalTo(20);
        }];
        _areaLabel.numberOfLines = 0;
        _areaLabel.textColor = [UIColor darkGrayColor];
        _areaLabel.font = [UIFont systemFontOfSize:kSize(14)];
    }
    return _areaLabel;
}

- (UILabel *)companyNameLabel {
    if (_companyNameLabel == nil) {
        _companyNameLabel = [UILabel new];
        [self.labelView addSubview:_companyNameLabel];
        [_companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeLabel.mas_bottom).equalTo(4);;
            make.right.equalTo(-12);
            make.left.equalTo(self.areaLabel.mas_right);
            make.bottom.equalTo(-4);
            make.height.equalTo(20);
        }];
        _companyNameLabel.numberOfLines = 0;
        _companyNameLabel.textAlignment = NSTextAlignmentRight;
        _companyNameLabel.textColor = [UIColor darkGrayColor];
        _companyNameLabel.font = [UIFont systemFontOfSize:kSize(14)];
    }
    return _companyNameLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(0);
            make.bottom.equalTo(self.labelView.mas_top);
        }];
        
    }
    return _imageView;
}

- (UIImageView *)QRCodeImageView {
    if (_QRCodeImageView == nil) {
        _QRCodeImageView = [[UIImageView alloc] init];
        [self addSubview:_QRCodeImageView];
        [_QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH*0.4, kSCREEN_WIDTH * 0.4));
            make.centerX.equalTo(0);
            make.centerY.equalTo(kSCREEN_HEIGHT/4.0);
        }];
//        _QRCodeImageView.backgroundColor = [UIColor lightGrayColor];
        
    }
    return _QRCodeImageView;
}

- (UILabel *)visitLabel {
    if (_visitLabel == nil) {
        _visitLabel = [UILabel new];
        [self addSubview:_visitLabel];
        [_visitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.equalTo(0);
            make.top.equalTo(self.labelView.mas_bottom);
            make.bottom.equalTo(self.QRCodeImageView.mas_top);
        }];
        _visitLabel.textAlignment  = NSTextAlignmentCenter;
        _visitLabel.font = [UIFont systemFontOfSize:kSize(40)];
        _visitLabel.text = @"邀请您参观工地";
    }
    return _visitLabel;
}

- (UILabel *)saveLabel {
    if (_saveLabel == nil) {
        _saveLabel = [UILabel new];
        [self addSubview:_saveLabel];
        [_saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(self.promptLabel.mas_top).equalTo(-12);
        }];
        _saveLabel.textAlignment = NSTextAlignmentCenter;
        _saveLabel.font = [UIFont systemFontOfSize:kSize(15)];
        _saveLabel.textColor = [UIColor darkGrayColor];
        _saveLabel.text = @"截屏保存到相册";
    }
    return _saveLabel;
}

- (UILabel *)promptLabel {
    if (_promptLabel == nil) {
        _promptLabel = [UILabel new];
        [self addSubview:_promptLabel];
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-18);
        }];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont systemFontOfSize:kSize(15)];
        _promptLabel.textColor = [UIColor darkGrayColor];
        _promptLabel.text = @"在微信环境下按住图片识别二维码打开";
    }
    return _promptLabel;
}
@end
