//
//  NewMeCell.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/5.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewMeCell.h"

@implementation NewMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UILabel *label = [[UILabel alloc] init];
    self.messageNumLabel = label;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.clipsToBounds = YES;
    label.text = @"0";
    label.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
