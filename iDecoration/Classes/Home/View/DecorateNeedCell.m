//
//  DecorateNeedCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorateNeedCell.h"

@implementation DecorateNeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self imageV];
    }
    return self;
}

- (void)setImageHeight:(CGFloat)imageHeight {
    _imageHeight = imageHeight;
    [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(-10);
        make.left.equalTo(10);
        make.height.equalTo(_imageHeight);
    }];
    [self layoutSubviews];
}

- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageV];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        [_imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.right.equalTo(-10);
            make.bottom.equalTo(-10);
            make.left.equalTo(10);
            make.height.equalTo(_imageHeight);
        }];
    }
    return _imageV;
}

@end
