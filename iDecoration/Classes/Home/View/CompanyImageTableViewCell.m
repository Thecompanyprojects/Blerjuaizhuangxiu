//
//  CompanyImageTableViewCell.m
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CompanyImageTableViewCell.h"

@implementation CompanyImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    _detailImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_detailImageView];
    [_detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
