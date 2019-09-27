//
//  ZCHSimpleSettingHeaderCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSimpleSettingHeaderCell.h"

@interface ZCHSimpleSettingHeaderCell()

@end

@implementation ZCHSimpleSettingHeaderCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.contentView.backgroundColor = kBackgroundColor;
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(0);
    }];
    
    self.switchBtn = [[UISwitch alloc] init];
    [self.contentView addSubview:self.switchBtn];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(49, 31));
    }];
    [self.switchBtn addTarget:self action:@selector(didClickSwitchBtn:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)didClickSwitchBtn:(UISwitch *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickSwitch:)]) {
        
        [self.delegate didClickSwitch:sender];
    }
}


@end
