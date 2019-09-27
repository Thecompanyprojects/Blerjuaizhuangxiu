//
//  StaffCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/11/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "StaffCell.h"

@implementation StaffCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageV.layer.cornerRadius = 6;
    self.imageV.layer.masksToBounds = YES;
}


- (void)setModel:(StaffModel *)model {
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.nameLabel.text = model.trueName.length > 0? model.trueName : @"";
    self.jobNameLabel.text = [NSString stringWithFormat:@"公司职位：%@", model.jobTypeName.length>0 ? model.jobTypeName : @""];
    self.jobMottoLabel.text = [NSString stringWithFormat:@"职业格言：%@", model.comment.length > 0 ? model.comment : @""];
}
@end
